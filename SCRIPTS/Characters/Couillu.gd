extends KinematicBody2D

export (int) var m_offsetTillFlip = 20
export (int) var m_AIMovementSpeed = 30

var m_moveDir = 1
var m_maxDistance = 600

var m_maxMoveTime = 1
var m_time = m_maxMoveTime

var m_maxTimeTileChoice = 1.2
var m_countDown = m_maxTimeTileChoice

var m_gKeys = []
var m_sKeys = []

var m_velocity = Vector2()

var m_startMoving = false
var m_isCrouching = false

var generalMoves = MoveSetManager.generalMoves

onready var animatedSprite = $AnimatedSprite

onready var gameRef = get_parent()

onready var player = get_parent().get_startscreen_node(gameRef.gamePlayer.name)

func _ready():
	m_gKeys = generalMoves.keys()
	m_countDown = m_maxTimeTileChoice

func _process(delta):
	
	m_countDown -= delta
	if(m_countDown < 0):
		ChooseNextAction()
	
	FacePlayer()
	
	if(m_startMoving && m_time > 0 && !m_isCrouching):
		MoveAI()
		m_time -= delta
	else:
		m_startMoving = false
		m_time = m_maxMoveTime

func ChooseNextAction():
	var percentagePerStep = float(100) / float(m_maxDistance)
	
	var chance = percentagePerStep * (abs(player.position.x - position.x))
	chance = 100 - clamp(chance, 10, 90)
	
	if(ReturnValue() <= chance):
		var randomAttack = RandomNumberGenerator.new()
		randomAttack.randomize()
		var attackValue = randomAttack.randi_range(0, m_gKeys.size() - 1)
		
		# Play an animation of an attack
		animatedSprite.play(generalMoves[m_gKeys[attackValue]])
	else:
		m_startMoving = true
		m_time = m_maxMoveTime
		Crouch(false)
		animatedSprite.play("Walk_forward")
	
	m_countDown = m_maxTimeTileChoice
	
func ReturnValue():
	var generator = RandomNumberGenerator.new()
	var value
	generator.randomize()
	value = generator.randi_range(0,100)
	
	return value

func FacePlayer():
	var distanceToPlayer = player.position.x - position.x
	
	if(distanceToPlayer > m_offsetTillFlip):
		m_moveDir = 1
		scale.x = scale.y * m_moveDir
	elif(distanceToPlayer < -m_offsetTillFlip):
		m_moveDir = -1
		scale.x = scale.y * m_moveDir
	else:
		m_moveDir = 0

func MoveAI():
	m_velocity = Vector2()
	m_velocity.x += m_moveDir * m_AIMovementSpeed
	m_velocity = move_and_slide(m_velocity)

func Crouch(var input):
	m_isCrouching = input


