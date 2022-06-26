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
