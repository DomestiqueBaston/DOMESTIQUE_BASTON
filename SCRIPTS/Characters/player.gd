extends KinematicBody2D

class_name Player

# player ONE is on the left facing right, player TWO is on the right facing left
enum { ONE, TWO }
export(int, "One", "Two") var player_number = ONE

# forward walking speed in pixels/second
export var forward_speed = 75

# backward walking speed in pixels/second
export var backward_speed = 50

# distance player is pushed backwards by a successful attack
const RETREAT_DISTANCE = 10

# speed at which player retreats after a successful attack, in pixels/second
const RETREAT_SPEED = 100

# logical actions and corresponding input map actions for each player
enum { FORWARD, BACKWARD, UP, DOWN, A, B }
var ui_actions = [
	[ "P1_right", "P1_left", "P1_up", "P1_down", "P1_a", "P1_b"],
	[ "P2_left", "P2_right", "P2_up", "P2_down", "P2_a", "P2_b"],
]

# damage wreaked by a successful attack
var attack_damage = {
	"Slap": 4,
	"Punch": 8,
	"Kick": 14,
	"Slash": 22,
	"Insult": 6
}

# this player's AnimationPlayer node
var anim_node

# the opponent's AnimationPlayer node
var opponent_anim_node

# true => player is doing something other than moving or idling
var busy = false

# true => opponent's move has been detected and either hit home or thwarted
var attack_processed = false

# distance player has to retreat as a result of a recent hit
var retreat_distance = 0

func _ready():
	anim_node = $AnimationPlayer
	anim_node.connect("animation_finished", self, "_on_animation_finished")
	var parent = get_parent()
	for index in parent.get_child_count():
		var sib = parent.get_child(index)
		if sib != self and sib.get_script() == get_script():
			opponent_anim_node = sib.get_node("AnimationPlayer")
			opponent_anim_node.connect(
				"animation_finished", self, "_on_opponent_animation_finished")
			break

func get_damage_for_attack(attack):
	var points = attack_damage.get(attack)
	return 0 if points == null else points

func is_defense_right_for_attack(defense, attack):
	if defense == "Crouch":
		return attack in ["Insult", "Slap"]
	elif defense == "Jump":
		return attack in ["Insult", "Kick"]
	elif defense == "Parry":
		return attack in ["Slash", "Slap", "Punch"]
	else:
		return false

func _input(event):
	
	# We are only interested in action press events. And if the player is doing
	# anything other than walking or playing a "trick", he/she cannot be
	# interrupted.

	if (not event.is_action_type() or not event.is_pressed()
		or (busy and anim_node.current_animation != "Trick")):
		return

	var my_actions = ui_actions[player_number]
	var anim_name = ""

	if Input.is_action_pressed(my_actions[B]):
		if Input.is_action_pressed(my_actions[FORWARD]):
			if Input.is_action_pressed(my_actions[UP]):
				anim_name = "Insult"
			elif Input.is_action_pressed(my_actions[DOWN]):
				anim_name = "Trick"
			else:
				anim_name = "Slash"
	elif Input.is_action_pressed(my_actions[A]):
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
		anim_node.play(anim_name)
		busy = true

func _physics_process(delta):
	var velocity = Vector2()

	if retreat_distance > 0:
		if retreat_distance > RETREAT_SPEED * delta:
			velocity.x -= RETREAT_SPEED
			retreat_distance -= RETREAT_SPEED * delta
		else:
			velocity.x -= retreat_distance / delta
			retreat_distance = 0

	if not busy:
		var my_actions = ui_actions[player_number]
		if Input.is_action_pressed(my_actions[FORWARD]):
			velocity.x += forward_speed
		elif Input.is_action_pressed(my_actions[BACKWARD]):
			velocity.x -= backward_speed
		if velocity.x > 0:
			anim_node.play("Walk_forward")
		elif velocity.x < 0:
			anim_node.play("Walk_backward")
		else:
			anim_node.play("Idle")

	if velocity.x != 0:
		if player_number == TWO:
			velocity.x = -velocity.x
		velocity = move_and_collide(velocity * delta)

func _on_animation_finished(_anim_name):
	busy = false

func _on_opponent_animation_finished(anim_name):
	if attack_processed:
		attack_processed = false
	elif get_damage_for_attack(anim_name) > 0:
		print(name, " was NOT hit by ", anim_name)

func _on_body_hit(_area_rid, _area, _area_shape_index, _local_shape_index):
	if not attack_processed:
		attack_processed = true
		var attack = opponent_anim_node.current_animation
		var damage = get_damage_for_attack(attack)
		if (damage > 0):
			print(name, " was hit by ", attack, ", damage: ", damage, " points")
			if attack != "Insult":
				retreat_distance += RETREAT_DISTANCE

func _on_defense_hit(_area_rid, _area, _area_shape_index, _local_shape_index):
	if not attack_processed:
		attack_processed = true
		var attack = opponent_anim_node.current_animation
		var defense = anim_node.current_animation
		if is_defense_right_for_attack(defense, attack):
			print(name, " thwarted ", attack, ", no damage")
		else:
			print(name, " thwarted ", attack, ", damage: ",
				  get_damage_for_attack(attack) / 2, " points")
			if attack != "Insult":
				retreat_distance += RETREAT_DISTANCE / 2.0
