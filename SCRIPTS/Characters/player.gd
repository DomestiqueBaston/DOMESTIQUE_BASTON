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
export var retreat_distance = 10

# speed at which player retreats after a successful attack, in pixels/second
export var retreat_speed = 100

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

# true => player is doing something other than walking or idling
var busy = false

# true => opponent's move has been detected and either hit home or thwarted
var attack_processed = false

# distance player has to retreat as a result of a recent hit
var remaining_retreat_distance = 0

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

# Returns the current frame number in the animation being played. This is the
# current animation position (in seconds) multiplied by 10, because the
# animation sequences are at 10 frames per second, so it is a real number.
#
func current_anim_frame():
	return anim_node.current_animation_position * 10

func _input(event):
	
	# We are only interested in action press events.

	if not event.is_action_type() or not event.is_pressed():
		return

	# Most actions cannot be interrupted, but there are two exceptions: Trick
	# can always be interrupted, and Get_hit can be interrupted starting at
	# frame 4 of the animation.
	
	if busy:
		var can_interrupt = false
		if anim_node.current_animation == "Trick":
			can_interrupt = true
		elif anim_node.current_animation == "Get_hit":
			can_interrupt = (current_anim_frame() >= 4)
		if not can_interrupt:
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
	var retreating = false

	if remaining_retreat_distance > 0:
		if remaining_retreat_distance > retreat_speed * delta:
			velocity.x -= retreat_speed
			remaining_retreat_distance -= retreat_speed * delta
		else:
			velocity.x -= remaining_retreat_distance / delta
			remaining_retreat_distance = 0
		retreating = true

	if not busy:
		var my_actions = ui_actions[player_number]
		if Input.is_action_pressed(my_actions[FORWARD]):
			velocity.x += forward_speed
			anim_node.play("Walk_forward")
		elif Input.is_action_pressed(my_actions[BACKWARD]):
			velocity.x -= backward_speed
			anim_node.play("Walk_backward")
		else:
			anim_node.play("Idle")

	# while retreating, turn off collision detection with the opponent but not
	# with the walls, which are layer 9

	var save_layer = collision_layer
	var save_mask = collision_mask

	if retreating:
		set_collision_layer(0)
		set_collision_mask(0x100)

	if velocity.x != 0:
		if player_number == TWO:
			velocity.x = -velocity.x
		var _collision = move_and_collide(velocity * delta)

	if retreating:
		set_collision_layer(save_layer)
		set_collision_mask(save_mask)

func _on_animation_finished(_anim_name):
	busy = false

func _on_opponent_animation_finished(anim_name):
	if attack_processed:
		attack_processed = false
	elif get_damage_for_attack(anim_name) > 0:
		print(name, " was NOT hit by ", anim_name)

func _on_body_hit(_area_rid, _area, _area_shape_index, _local_shape_index):
	if attack_processed:
		return
	attack_processed = true
	var attack = opponent_anim_node.current_animation
	var damage = get_damage_for_attack(attack)
	if damage > 0:
		print(name, " was hit by ", attack, ", damage: ", damage, " points")
		play_get_hit_animation()
		if attack == "Insult":
			play_insult_hit_effect()
		else:
			play_hit_effect()
			remaining_retreat_distance += retreat_distance

func _on_defense_hit(_area_rid, _area, _area_shape_index, _local_shape_index):
	if attack_processed:
		return
	attack_processed = true
	var attack = opponent_anim_node.current_animation
	var defense = anim_node.current_animation
	if is_defense_right_for_attack(defense, attack):
		print(name, " thwarted ", attack, ", no damage")
	else:
		print(name, " thwarted ", attack, ", damage: ",
			  get_damage_for_attack(attack) / 2, " points")
		play_get_hit_animation()
		if attack != "Insult":
			remaining_retreat_distance += retreat_distance / 2.0
	if defense == "Parry":
		if attack == "Insult":
			play_insult_miss_effect()
		else:
			play_miss_effect()

func play_effect_once(scene, pos):
	var effect = scene.instance()
	effect.position = pos
	effect.scale.x = -1 if player_number == ONE else 1
	get_tree().current_scene.add_child(effect)
	yield(effect.get_node("AnimationPlayer"), "animation_finished")
	effect.queue_free()

func play_hit_effect():
	play_effect_once(
		preload("res://SCENES/Hit_Effect.tscn"),
		get_node("Area2D_Body/BodyCollider").global_position)

func play_insult_hit_effect():
	play_effect_once(
		preload("res://SCENES/Insult_Hit_Effect.tscn"),
		get_node("Area2D_Body/BodyCollider").global_position)

func play_miss_effect():
	play_effect_once(
		preload("res://SCENES/Miss_Effect.tscn"),
		get_node("Area2D_Defense/DefenseCollider").global_position)

func play_insult_miss_effect():
	play_effect_once(
		preload("res://SCENES/Insult_Miss_Effect.tscn"),
		get_node("Area2D_Defense/DefenseCollider").global_position)

func play_get_hit_animation():
	var defense = anim_node.current_animation
	var play_it = true

	if defense == "Jump":
		var frame = current_anim_frame()
		if frame >= 4 and frame < 8:
			play_it = false
	elif defense == "Crouch":
		var frame = current_anim_frame()
		if frame >= 2 and frame < 7:
			play_it = false

	if play_it:
		anim_node.play("Get_hit")
		busy = true
	else:
		$Flasher.stop()
		$Flasher.play("Flash")
