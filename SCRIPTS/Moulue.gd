extends KinematicBody2D


const SPEED = 50
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

var isDoingSomething = false


func _physics_process(_delta):
	if Input.is_action_pressed("ui_right") && isDoingSomething == false:
		velocity.x = SPEED * 1.5
		$AnimatedSprite.play("Walk_forward")
	elif Input.is_action_pressed("ui_left") && isDoingSomething == false:
		velocity.x = -SPEED
		$AnimatedSprite.play("Walk_backward")
	else:
		velocity.x = 0
		if isDoingSomething == false:
			$AnimatedSprite.play("Idle")
		
	if Input.is_action_just_pressed("ui_down") && isDoingSomething == false:
		$AnimatedSprite.play("Crouch")
		isDoingSomething = true
		
	elif Input.is_action_just_pressed("ui_up") && isDoingSomething == false:
		$AnimatedSprite.play("Jump")
		isDoingSomething = true

	elif Input.is_action_just_pressed("top_right") && isDoingSomething == false:
		$AnimatedSprite.play("Parry")
		isDoingSomething = true

	elif Input.is_action_just_pressed("ui_a") && isDoingSomething == false:
		$AnimatedSprite.play("Punch")
		isDoingSomething = true

	elif Input.is_action_just_pressed("ui_b") && isDoingSomething == false:
		$AnimatedSprite.play("Kick")
		isDoingSomething = true

	elif Input.is_action_just_pressed("ui_y") && isDoingSomething == false:
		$AnimatedSprite.play("Insult")
		isDoingSomething = true

	elif Input.is_action_just_pressed("ui_x") && isDoingSomething == false:
		$AnimatedSprite.play("Slap")
		isDoingSomething = true

	elif Input.is_action_just_pressed("top_left") && isDoingSomething == false:
		$AnimatedSprite.play("Trick")
		isDoingSomething = true

	elif Input.is_action_just_pressed("bottom_left") && isDoingSomething == false:
		$AnimatedSprite.play("Slash")
		isDoingSomething = true
		
	velocity = move_and_slide(velocity, FLOOR)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation != "Walk_forward" and $AnimatedSprite.animation != "Walk_backward" and $AnimatedSprite.animation != "Idle":
		isDoingSomething = false
		
		
		
		


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
