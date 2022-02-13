extends KinematicBody2D


const SPEED = 50
const FLOOR = Vector2(0, -1)

var velocity = Vector2()


func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED * 1.66
		$AnimatedSprite.play("Walk_forward")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED * 0.85
		$AnimatedSprite.play("Walk_backward")
	else:
		velocity.x = 0
		$AnimatedSprite.play("Idle")
		
	velocity = move_and_slide(velocity, FLOOR)






#extends KinematicBody2D
#
#
#export var speed = 50
#
#var velocity = Vector2()
#
#func get_input():
#	velocity = Vector2()
#	if Input.is_action_pressed("ui_right"):
#		velocity.x += 1
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= 1
#	velocity = velocity * speed
#
#
#func _physics_process(delta):
#	get_input()
#	velocity = move_and_slide(velocity)






