extends KinematicBody2D

class_name Player

## Player ONE is on the left facing right, player TWO on the right facing left.
enum { ONE, TWO }
export(int, "One", "Two") var player_number = ONE

## Forward walking speed in pixels/second.
export var forward_speed = 75

## Backward walking speed in pixels/second.
export var backward_speed = 50

## Distance player is pushed backwards by a successful attack.
export var retreat_distance = 10

## Speed at which player retreats after a successful attack, in pixels/second.
export var retreat_speed = 100

## Distance opponent is pushed backwards if player parries twice in a row.
export var parry_push_back = 25

## Energy points the player starts out with.
export var initial_energy = 100

## When transitioning from a Crouch to a Slap auto-attack, stop the Crouch
## animation at frame A and start the Slap animation at frame B, where A and B
## are the two array elements.
export var crouch_to_slap_frames = [ 6, 3 ]

## When transitioning from a Jump to a Kick auto-attack, stop the Jump
## animation at frame A and start the Kick animation at frame B, where A and B
## are the two array elements.
export var jump_to_kick_frames = [ 10, 4 ]

## Signal emitted when the player's energy level changes. Passes a single
## argument whose value is between 0 (dead) and 1.
signal energy_changed

## Signal emitted when the player has been knocked out.
signal knockout

# the three states of gameplay
enum { WAITING, PLAYING, DEAD }
var state = WAITING

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

# the opponent's root node
var opponent_node

# the opponent's AnimationPlayer node
var opponent_anim_node

# current energy level (starts at initial_energy)
var current_energy

# true => player is doing something other than walking or idling
var busy = false

# true => opponent's move has been detected and either hit home or thwarted
var attack_processed = false

# true => this player's attacks cannot be thwarted (temporarily)
var irresistible = false

# distance player has to retreat as a result of a recent hit
var remaining_retreat_distance = 0

# the last animation that was played (other than walking or idling)
var last_animation

# the time in milliseconds when last_animation finished
var last_animation_end_time

# how many times in a row the current animation has played
var animation_repeat_count = 1

# animations are at 10 frames per second
const FPS = 10.0

##
## Note that the player will Idle until start() is called.
##
func _ready():
	anim_node = $AnimationPlayer
	var parent = get_parent()
	for index in parent.get_child_count():
		var sib = parent.get_child(index)
		if sib != self and sib.get_script() == get_script():
			opponent_node = sib
			opponent_anim_node = sib.get_node("AnimationPlayer")
			opponent_anim_node.connect(
				"animation_finished", self, "_on_opponent_animation_finished")
			break

	current_energy = initial_energy

	# play the In animation, then loop the Idle animation until start() is
	# called

	set_state(WAITING)
	anim_node.play("In")
	yield(anim_node, "animation_finished")
	anim_node.get_animation("Idle").loop = true
	anim_node.play("Idle")

##
## Start playing. Until this is called, input events and physics are disabled.
##
func start():
	anim_node.get_animation("Idle").loop = false
	set_state(PLAYING)

func set_state(new_state):
	state = new_state
	set_process_input(new_state == PLAYING)
	set_physics_process(new_state == PLAYING)

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

##
## Returns the current frame number in the animation being played. This is the
## current animation position (in seconds) multiplied by FPS, because the
## animation sequences are at FPS frames per second, so it is a real number.
##
func current_anim_frame():
	return anim_node.current_animation_position * FPS

func _input(event):
	
	# we are only interested in action press events

	if not event.is_action_type() or not event.is_pressed():
		return

	# most actions cannot be interrupted, but there are two exceptions: Trick
	# and Get_hit can be interrupted starting at frame 4 of their respective
	# animations

	if (busy
		and (not anim_node.current_animation in [ "Trick", "Get_hit" ]
			 or current_anim_frame() < 4)):
		return

	var my_actions = ui_actions[player_number]

	if Input.is_action_pressed(my_actions[B]):
		if Input.is_action_pressed(my_actions[FORWARD]):
			if Input.is_action_pressed(my_actions[UP]):
				if play_animation("Insult"):
					var audio_name = "InsultPlayer" + str(randi() % 3 + 1)
					get_node(audio_name).play()
			elif Input.is_action_pressed(my_actions[DOWN]):
				play_animation("Slash")
			else:
				play_animation("Trick")
		elif Input.is_action_pressed(my_actions[BACKWARD]):
			if Input.is_action_pressed(my_actions[UP]):
				play_animation("Jump")
			elif Input.is_action_pressed(my_actions[DOWN]):
				play_animation("Crouch")
			else:
				play_animation("Parry")
	elif Input.is_action_pressed(my_actions[A]):
		if Input.is_action_pressed(my_actions[FORWARD]):
			if Input.is_action_pressed(my_actions[UP]):
				play_animation("Slap")
			elif Input.is_action_pressed(my_actions[DOWN]):
				play_animation("Kick")
			else:
				play_animation("Punch")
		elif Input.is_action_pressed(my_actions[BACKWARD]):
			if Input.is_action_pressed(my_actions[UP]):
				play_animation("Jump")
			elif Input.is_action_pressed(my_actions[DOWN]):
				play_animation("Crouch")
			else:
				play_animation("Parry")

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

##
## Call this to trigger an animation other than walking or idle. It starts the
## animation (if it not playing already) and sets the busy flag, which will be
## reset when the animation finishes. It also updates the variables
## last_animation, last_animation_end_time and animation_repeat_count.
##
## If the given animation is an attack, and the player has already used the same
## attack twice in a row, the attack is ignored and false is returned. The
## player can use the attack again after taking a hit (anim_name Get_hit) or
## making a defensive move.
##
func play_animation(anim_name):
	if last_animation == anim_name:
		animation_repeat_count += 1
		if animation_repeat_count > 2 && get_damage_for_attack(anim_name) > 0:
			return false
	else:
		last_animation = anim_name
		animation_repeat_count = 1
	anim_node.play(anim_name)
	busy = true
	yield(anim_node, "animation_finished")
	busy = false
	last_animation_end_time = OS.get_ticks_msec()
	return true

func _on_opponent_animation_finished(_anim_name):
	attack_processed = false

##
## Callback invoked when the other player's attack collider hits this player's
## body collider (we've been hit).
##
func _on_body_hit(_area_rid, _area, _area_shape_index, _local_shape_index):
	if attack_processed:
		return

	attack_processed = true
	var attack = opponent_anim_node.current_animation
	var damage = get_damage_for_attack(attack)

	if damage > 0:
		var defense = anim_node.current_animation
		take_hit(damage)
		if attack == "Insult":
			play_insult_hit_effect()
		else:
			play_hit_effect()
			retreat(retreat_distance)
		if defense == "Parry":
			check_for_second_parry()

##
## Callback invoked when the other player's attack collider hits this player's
## defense collider (we've blocked an attack).
##
func _on_defense_hit(_area_rid, _area, _area_shape_index, _local_shape_index):
	if attack_processed or opponent_node.irresistible:
		return

	attack_processed = true
	var attack = opponent_anim_node.current_animation
	var defense = anim_node.current_animation

	if defense == "Parry":
		if attack == "Insult":
			play_insult_miss_effect()
		else:
			play_miss_effect()
		check_for_second_parry()

	if is_defense_right_for_attack(defense, attack):
		var auto_attack
		var stop_start_frames

		if defense == "Crouch":
			auto_attack = "Slap"
			stop_start_frames = crouch_to_slap_frames
		elif defense == "Jump":
			auto_attack = "Kick"
			stop_start_frames = jump_to_kick_frames

		if auto_attack:
			var anim = anim_node.get_animation(defense)
			var saved_length = anim.length
			anim.length = stop_start_frames[0] / FPS
			yield(anim_node, "animation_finished")
			anim.length = saved_length

			play_animation(auto_attack)
			anim_node.seek(stop_start_frames[1] / FPS)
			irresistible = true
			yield(anim_node, "animation_finished")
			irresistible = false

	else:
		var damage = get_damage_for_attack(attack) / 2
		take_hit(damage)
		if attack != "Insult":
			retreat(retreat_distance / 2.0)

##
## If the last animation was a Parry, and the current Parry started less than
## half a second later, push the opponent backwards. (It is assumed that the
## current action is also a Parry, and that we just took or thwarted a hit.)
##
func check_for_second_parry():
	if last_animation == "Parry":
		var start_time = \
			OS.get_ticks_msec() - 1000 * anim_node.current_animation_position
		if start_time - last_animation_end_time < 500:
			opponent_node.retreat(parry_push_back)

##
## Causes the player to retreat by the given distance (in pixels).
##
func retreat(dist):
	remaining_retreat_distance += dist

##
## Adds an instance of the given scene to the tree at the given position, then
## deletes it when its AnimationPlayer has finished (it is assumed that the
## AnimationPlayer autoplays). Note that the scene is flipped in X for player
## one.
##
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

##
## Subtracts the given number of points from the player's energy level.
## Triggers the Get_hit animation unless the player is in the middle of a jump
## (in the air) or a crouch (on the ground). In either of those cases, the
## player's sprite flashes instead.
##
func take_hit(damage):
	if state != PLAYING:
		return

	current_energy = max(0, current_energy - damage)
	emit_signal("energy_changed", current_energy as float / initial_energy)

	if current_energy == 0:
		play_animation("Ko")
		set_state(DEAD)
		yield(anim_node, "animation_finished")
		emit_signal("knockout")
		return

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
		play_animation("Get_hit")
	else:
		$Flasher.stop()
		$Flasher.play("Flash")
