extends KinematicBody2D

const SPEED = 50
const FLOOR = Vector2.UP

var animation
var busy = false

func _ready():
	animation = $AnimationPlayer
	animation.connect("animation_finished", self, "_on_animation_finished")

func _input(event):
	if busy:
		return

	var anim_name = ""

	if event.is_action_pressed("ui_a"):
		if Input.is_action_pressed("ui_right"):
			if Input.is_action_pressed("ui_up"):
				anim_name = "Insult"
			elif Input.is_action_pressed("ui_down"):
				anim_name = "Trick"
			else:
				anim_name = "Slash"
	elif event.is_action_pressed("ui_b"):
		if Input.is_action_pressed("ui_right"):
			if Input.is_action_pressed("ui_up"):
				anim_name = "Slap"
			elif Input.is_action_pressed("ui_down"):
				anim_name = "Kick"
			else:
				anim_name = "Punch"
		elif Input.is_action_pressed("ui_left"):
			if Input.is_action_pressed("ui_up"):
				anim_name = "Jump"
			elif Input.is_action_pressed("ui_down"):
				anim_name = "Crouch"
			else:
				anim_name = "Parry"

	if not anim_name.empty():
		animation.play(anim_name)
		busy = true

func _physics_process(_delta):
	var velocity = Vector2()
	if not busy:
		if Input.is_action_pressed("ui_right"):
			velocity.x = SPEED * 1.5
			animation.play("Walk_forward")
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -SPEED
			animation.play("Walk_backward")
		else:
			animation.play("Idle")
	velocity = move_and_slide(velocity, FLOOR)

func _on_animation_finished(_anim_name):
	busy = false
