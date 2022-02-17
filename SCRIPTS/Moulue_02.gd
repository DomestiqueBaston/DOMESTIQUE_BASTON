extends KinematicBody2D


const SPEED = 50
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var isDoingSomething = false

onready var animationstate = $AnimationTree.get("parameters/playback")

func _print_animation():
	print($AnimationTree.get("parameters/playback"))
	print(animationstate)


func _physics_process(_delta):
	if Input.is_action_pressed("ui_right") && isDoingSomething == false:
		velocity.x = SPEED * 1.5
		animationstate.travel("Walk_forward")
	elif Input.is_action_pressed("ui_left") && isDoingSomething == false:
		velocity.x = -SPEED
		animationstate.travel("Walk_backward")
	elif Input.is_action_just_pressed("ui_a") && isDoingSomething == false:
		animationstate.travel("Punch")
#		isDoingSomething = true
		_print_animation()
	else:
		velocity.x = 0
		if isDoingSomething == false:
			animationstate.travel("Idle")

	velocity = move_and_slide(velocity, FLOOR)


func _on_AnimatedSprite_animation_finished():
	if animationstate.animation != "Walk_forward" and animationstate.animation != "Walk_backward" and animationstate.animation != "Idle":
		isDoingSomething = false


#extends KinematicBody2D
#
#var velocity = Vector2.ZERO
#
#const SPEED = 120
#const ACCELERATION = 250
#const GRAVITY = 400
#
#onready var animationPlayer = $AnimationPlayer
#onready var animationtree = $AnimationTree
#onready var animationstate = animationtree.get("parameters/playback")
#
#func _physics_process(delta):
#	var position = Vector2.ZERO
#	position.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#
#	if position > Vector2.ZERO:
#		velocity = velocity.move_toward(position * SPEED, ACCELERATION * delta)
#		animationstate.travel("Walk_forward")
#	elif position < Vector2.ZERO:
#		velocity = velocity.move_toward(SPEED * 1.5, ACCELERATION * delta)
#		animationstate.travel("Walk_backward")
#	else:
#		velocity = velocity.move_toward(Vector2.ZERO, GRAVITY * delta)
#		animationstate.travel("Idle")
#	move_and_slide(velocity)
