extends KinematicBody2D

const SPEED = 50
const FLOOR = Vector2.UP #Vector2(0, -1)

var velocity = Vector2()
var busy = false

func _physics_process(_delta):
	if busy:
		velocity.x = 0
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED * 1.5
		$AnimatedSprite.play("Walk_forward")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$AnimatedSprite.play("Walk_backward")
	else:
		velocity.x = 0
		$AnimatedSprite.play("Idle")

	if !busy:
		if Input.is_action_pressed("top_left") && Input.is_action_pressed("top_right"):
			$AnimatedSprite.play("Parry")
			busy = true
		elif Input.is_action_just_pressed("top_left"):
			$AnimatedSprite.play("Crouch")
			busy = true
		elif Input.is_action_just_pressed("top_right"):
			$AnimatedSprite.play("Jump")
			busy = true
		elif Input.is_action_pressed("ui_a") && Input.is_action_pressed("ui_b"):
			$AnimatedSprite.play("Slap")
			busy = true
		elif Input.is_action_just_pressed("ui_a"):
			$AnimatedSprite.play("Punch")
			busy = true
		elif Input.is_action_just_pressed("ui_b"):
			$AnimatedSprite.play("Kick")
			busy = true
		elif Input.is_action_pressed("ui_x") && Input.is_action_pressed("ui_y"):
			$AnimatedSprite.play("Slash")
			busy = true
		elif Input.is_action_just_pressed("ui_x"):
			$AnimatedSprite.play("Insult")
			busy = true
		elif Input.is_action_just_pressed("ui_y"):
			$AnimatedSprite.play("Trick")
			busy = true

	velocity = move_and_slide(velocity, FLOOR)

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation != "Walk_forward" and $AnimatedSprite.animation != "Walk_backward" and $AnimatedSprite.animation != "Idle":
		busy = false
		
		
		
		


#extends KinematicBody2D
#
#
#const SPEED = 50
#const FLOOR = Vector2(0, -1)
#
#var velocity = Vector2()
#
#
#func _physics_process(_delta):
#	if Input.is_action_pressed("ui_right"):
#		velocity.x = SPEED * 1.5
#		$AnimatedSpriteplay("Walk_forward")
#	elif Input.is_action_pressed("ui_left"):
#		velocity.x = -SPEED
#		$AnimatedSpriteplay("Walk_backward")
#	else:
#		velocity.x = 0
#		$AnimatedSpriteplay("Idle")
#
#	velocity = move_and_slide(velocity, FLOOR)
