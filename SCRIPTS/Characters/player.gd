extends KinematicBody2D

class_name Player

enum PlayerNumber { ONE, TWO }
export(PlayerNumber) var player_number = PlayerNumber.ONE

enum { FORWARD, BACKWARD, UP, DOWN, A, B }

var ui_actions = [
	[ "P1_right", "P1_left", "P1_up", "P1_down", "P1_a", "P1_b"],
	[ "P2_left", "P2_right", "P2_up", "P2_down", "P2_a", "P2_b"],
]

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

	var my_actions = ui_actions[player_number]
	var anim_name = ""

	if event.is_action_pressed(my_actions[A]):
		if Input.is_action_pressed(my_actions[FORWARD]):
			if Input.is_action_pressed(my_actions[UP]):
				anim_name = "Insult"
			elif Input.is_action_pressed(my_actions[DOWN]):
				anim_name = "Trick"
			else:
				anim_name = "Slash"
	elif event.is_action_pressed(my_actions[B]):
		if Input.is_action_pressed(my_actions[FORWARD]):
			if Input.is_action_pressed(my_actions[UP]):
				anim_name = "Slap"
			elif Input.is_action_pressed(my_actions[DOWN]):
				anim_name = "Kick"
			else:
				anim_name = "Punch"
		elif Input.is_action_pressed(my_actions[BACKWARD]):
			if Input.is_action_pressed(my_actions[UP]):
				anim_name = "Jump"
			elif Input.is_action_pressed(my_actions[DOWN]):
				anim_name = "Crouch"
			else:
				anim_name = "Parry"

	if not anim_name.empty():
		animation.play(anim_name)
		busy = true

func _physics_process(_delta):
	var velocity = Vector2()
	if not busy:
		var my_actions = ui_actions[player_number]
		if Input.is_action_pressed(my_actions[FORWARD]):
			velocity.x = SPEED * 1.5
			animation.play("Walk_forward")
		elif Input.is_action_pressed(my_actions[BACKWARD]):
			velocity.x = -SPEED
			animation.play("Walk_backward")
		else:
			animation.play("Idle")
	if player_number == PlayerNumber.TWO:
		velocity.x = -velocity.x
	velocity = move_and_slide(velocity, FLOOR)

func _on_animation_finished(_anim_name):
	busy = false
