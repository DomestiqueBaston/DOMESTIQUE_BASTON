extends KinematicBody2D

class_name Player

enum { ONE, TWO }
export(int, "One", "Two") var player_number = ONE

export var forward_speed = 75
export var backward_speed = 50

enum { FORWARD, BACKWARD, UP, DOWN, A, B }
var ui_actions = [
	[ "P1_right", "P1_left", "P1_up", "P1_down", "P1_a", "P1_b"],
	[ "P2_left", "P2_right", "P2_up", "P2_down", "P2_a", "P2_b"],
]

var attack_damage = {
	"Slap": 4,
	"Punch": 8,
	"Kick": 14,
	"Slash": 22,
	"Insult": 6
}

var anim_node
var opponent_anim_node
var busy = false
var attack_processed = false
var backup_distance = 0

func _ready():
	anim_node = $AnimationPlayer
	anim_node.connect("animation_finished", self, "_on_animation_finished")
	var parent = get_parent()
	for index in parent.get_child_count():
		var sib = parent.get_child(index)
		if sib != self and sib.get_script() == get_script():
			opponent_anim_node = sib.get_node("AnimationPlayer")
			opponent_anim_node.connect("animation_finished", self, "_on_opponent_animation_finished")
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

	if not busy:
		var my_actions = ui_actions[player_number]
		if Input.is_action_pressed(my_actions[FORWARD]):
			velocity.x = forward_speed
			anim_node.play("Walk_forward")
		elif Input.is_action_pressed(my_actions[BACKWARD]):
			velocity.x = -backward_speed
			anim_node.play("Walk_backward")
		else:
			anim_node.play("Idle")
		if player_number == TWO:
			velocity.x = -velocity.x

	if backup_distance > 0:
		if player_number == ONE:
			position.x -= backup_distance
		else:
			position.x += backup_distance
		backup_distance = 0

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
		var attack = opponent_anim_node.current_animation
		attack_processed = true
		print(name, " was hit by ", attack, ", damage: ",
			  get_damage_for_attack(attack), " points")
		backup_distance += 20

func _on_defense_hit(_area_rid, _area, _area_shape_index, _local_shape_index):
	if not attack_processed:
		var attack = opponent_anim_node.current_animation
		var defense = anim_node.current_animation
		attack_processed = true
		if is_defense_right_for_attack(defense, attack):
			print(name, " thwarted ", attack, ", no damage")
		else:
			print(name, " thwarted ", attack, ", damage: ",
				  get_damage_for_attack(attack) / 2, " points")
			backup_distance += 10
