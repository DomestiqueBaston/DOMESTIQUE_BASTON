extends KinematicBody2D

const SPEED = 50
const FLOOR = Vector2.UP #Vector2(0, -1)

var animation
var velocity = Vector2()
var busy = false

func _ready():
	animation = $AnimationPlayer
	animation.connect("animation_finished", self, "_on_animation_finished")

func _physics_process(_delta):
	if !busy:
		if Input.is_action_just_pressed("ui_a"):
			if Input.is_action_pressed("ui_right"):
				if Input.is_action_pressed("ui_up"):
					animation.play("Insult")
					busy = true
				elif Input.is_action_pressed("ui_down"):
					animation.play("Trick")
					busy = true
				else:
					animation.play("Slash")
					busy = true
		elif Input.is_action_just_pressed("ui_b"):
			if Input.is_action_pressed("ui_right"):
				if Input.is_action_pressed("ui_up"):
					animation.play("Slap")
					busy = true
				elif Input.is_action_pressed("ui_down"):
					animation.play("Kick")
					busy = true
				else:
					animation.play("Punch")
					busy = true
			elif Input.is_action_pressed("ui_left"):
				if Input.is_action_pressed("ui_up"):
					animation.play("Jump")
					busy = true
				elif Input.is_action_pressed("ui_down"):
					animation.play("Crouch")
					busy = true
				else:
					animation.play("Parry")
					busy = true

	if busy:
		velocity.x = 0
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED * 1.5
		animation.play("Walk_forward")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		animation.play("Walk_backward")
	else:
		velocity.x = 0
		animation.play("Idle")

	velocity = move_and_slide(velocity, FLOOR)

func _on_animation_finished(anim_name):
	if anim_name != "Walk_forward" and anim_name != "Walk_backward" and anim_name != "Idle":
		busy = false
