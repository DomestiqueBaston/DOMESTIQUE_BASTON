extends KinematicBody2D


#Float
var timeTillNextInput = 0.2
var time = timeTillNextInput

#Integer

#Boolean
var wasInputMade = false
var isCrouching = false

#Array
var usedKeys = []

#Vector

#Object
onready var playerAnimTree = $AnimationTree.get("parameters/playback")

#References
var generalMoveSetAnims = MoveSetManager.nameDictionary["generalMoves"]
var specificMoveSetAnims = MoveSetManager.nameDictionary["moulueMoves"]

func _ready():
	pass
	
func _input(event):
#If there is an Input made, signal it only once
	if event is InputEventKey:
		if event.pressed and not event.echo:
			
			#Make a new temp variable to store our input in
			var character = OS.get_scancode_string(event.scancode)
			
			#check if the input made is also allowed to be used
			if "WASDLP".find(character) >= 0:
				wasInputMade = true
				time = timeTillNextInput
				usedKeys.append(character)
	
func _process(delta):
	if (wasInputMade):
		time -= delta
		
		#The usual if time ran out situation but this time send the eventual result of inputs
		if (time < 0 && usedKeys != null):
			_send_combo_attempt(usedKeys)
			wasInputMade = false
			time = timeTillNextInput
			usedKeys.clear()
			return
			
	if (Input.is_action_just_pressed("down")):
		playerAnimTree.travel(generalMoveSetAnims [5])
		isCrouching = true
		return
	else:
		playerAnimTree.travel(generalMoveSetAnims[6])
		isCrouching = false
		return
	
func _send_combo_attempt(var attempt = []):
	#If the "attempt" array has only 1 value in ti, chaeck if all of these inputs form an actual combo
	if (attempt.size() > 1):
		if (attempt in specificMoveSetAnims[name]):
			playerAnimTree.travel(specificMoveSetAnims[name][attempt])
	

