extends Control


# Navigation
var previous_vpos := 0
var current_vpos := 0
var previous_hpos := 0
var current_hpos := 0

var previous_node := ""
var current_node := "0_0"

#var line_name = ""
var concerned_bus



func _ready():
	get_node("0_" + str(PreloadScript01.commentaires)).modulate = PreloadScript01.VIOLET
	if get_node("0_0").modulate == Color(1,1,1):
		get_node("0_0").modulate = PreloadScript01.BLACK
	else:
		get_node("0_0").modulate = PreloadScript01.HALF
	get_node("1_" + str(PreloadScript01.bruitages)).modulate = PreloadScript01.VIOLET
	get_node("2_" + str(PreloadScript01.musique)).modulate = PreloadScript01.VIOLET

func _input(event):
	if (Input.is_action_just_pressed('P1_down')) or (Input.is_action_just_pressed('P2_down')):
		previous_vpos = current_vpos
		check_previous_boundaries()
		current_vpos += 1
		check_current_boundaries()
		previous_node = str(previous_vpos) + "_" + str(current_hpos)
		current_node = str(current_vpos) + "_" + str(current_hpos)
		play_wooowdown()
		turn_on_off()

	elif (Input.is_action_just_pressed('P1_up')) or (Input.is_action_just_pressed('P2_up')):
		previous_vpos = current_vpos
		check_previous_boundaries()
		current_vpos -= 1
		check_current_boundaries()
		previous_node = str(previous_vpos) + "_" + str(current_hpos)
		current_node = str(current_vpos) + "_" + str(current_hpos)
		play_wooowdown()
		turn_on_off()

	elif (Input.is_action_just_pressed('P1_right')) or (Input.is_action_just_pressed('P2_right')):
		previous_hpos = current_hpos
		check_previous_boundaries()
		current_hpos += 1
		check_current_boundaries()
		previous_node = str(current_vpos) + "_" + str(previous_hpos)
		current_node = str(current_vpos) + "_" + str(current_hpos)
		play_wooowdown()
		turn_on_off()

	elif (Input.is_action_just_pressed('P1_left')) or (Input.is_action_just_pressed('P2_left')):
		previous_hpos = current_hpos
		check_previous_boundaries()
		current_hpos -= 1
		check_current_boundaries()
		previous_node = str(current_vpos) + "_" + str(previous_hpos)
		current_node = str(current_vpos) + "_" + str(current_hpos)
		play_wooow()
		turn_on_off()

	elif (Input.is_action_just_pressed('P1_a')) or (Input.is_action_just_pressed('P2_a')):
		validation()
	
	elif event is InputEventJoypadButton and event.pressed:
		set_process_input(false)
		play_cancel()
		get_node("../TransitionScreen").transition()
		
	elif event is InputEventKey and event.pressed:
		if (Input.is_key_pressed(KEY_ALT)):
			pass
		elif (Input.is_key_pressed(KEY_ENTER)):
			pass
		else:
			set_process_input(false)
			play_cancel()
			get_node("../TransitionScreen").transition()
		
func check_previous_boundaries():
	if previous_vpos < 0:
		previous_vpos = 2
	elif previous_vpos > 2:
		previous_vpos = 0
	elif previous_hpos < 0:
		previous_hpos = 3
	elif previous_hpos > 3:
		previous_hpos = 0

func check_current_boundaries():
	if current_vpos < 0:
		current_vpos = 2
	elif current_vpos > 2:
		current_vpos = 0
	elif current_hpos < 0:
		current_hpos = 3
	elif current_hpos > 3:
		current_hpos = 0

# Validation of level values
func validation():
	if get_node(current_node).modulate.a != 1:
		get_node(current_node).modulate = PreloadScript01.BLACK
		if current_vpos == 0:
			get_node("0_" + str(PreloadScript01.commentaires)).modulate = PreloadScript01.WHITE
			PreloadScript01.commentaires = current_hpos
#			line_name = "commentaires_value"
			concerned_bus = current_vpos + 1
			change_sound_level()
			play_validation()
		elif current_vpos == 1:
			get_node("1_" + str(PreloadScript01.bruitages)).modulate = PreloadScript01.WHITE
			PreloadScript01.bruitages = current_hpos
#			line_name = "bruitages_value"
			concerned_bus = current_vpos + 1
			change_sound_level()
			play_validation()
		else:
			get_node("2_" + str(PreloadScript01.musique)).modulate = PreloadScript01.WHITE
			PreloadScript01.musique = current_hpos
#			line_name = "musique_value"
			concerned_bus = current_vpos + 1
			change_sound_level()
			play_validation()
			get_node('/root/MusicController/Music').volume_db = PreloadScript01.musique_value
			
# Cursor color management
func turn_on_off():
	if get_node(previous_node).modulate.a == 1 and get_node(current_node).modulate.a == 1:
		get_node(previous_node).modulate = PreloadScript01.VIOLET
		get_node(current_node).modulate = PreloadScript01.BLACK
	elif get_node(previous_node).modulate.a == 1:
		get_node(previous_node).modulate = PreloadScript01.VIOLET
		get_node(current_node).modulate = PreloadScript01.HALF
	elif get_node(current_node).modulate.a == 1:
		get_node(current_node).modulate = PreloadScript01.BLACK
		get_node(previous_node).modulate = PreloadScript01.WHITE
	else:
		get_node(previous_node).modulate = PreloadScript01.WHITE
		get_node(current_node).modulate = PreloadScript01.HALF

func _on_TransitionScreen_transitioned():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SCENES/Start_Screen.tscn")
	
func change_sound_level():
	if current_hpos == 0:
#		PreloadScript01.set(line_name, PreloadScript01.NO_SOUND_LEVEL)
		AudioServer.set_bus_volume_db(concerned_bus, PreloadScript01.NO_SOUND_LEVEL)
	elif current_hpos == 1:
#		PreloadScript01.set(line_name, PreloadScript01.HALF_LEVEL)
		AudioServer.set_bus_volume_db(concerned_bus, PreloadScript01.HALF_LEVEL)
	elif current_hpos == 2:
#		PreloadScript01.set(line_name, PreloadScript01.NORMAL_LEVEL)
		AudioServer.set_bus_volume_db(concerned_bus, PreloadScript01.NORMAL_LEVEL)
	else:
#		PreloadScript01.set(line_name, PreloadScript01.MORE_THAN_FULL_LEVEL)
		AudioServer.set_bus_volume_db(concerned_bus, PreloadScript01.MORE_THAN_FULL_LEVEL)

func play_validation():
#	$AudioValid.volume_db = PreloadScript01.bruitages_value
	$AudioValid.play()
	
func play_cancel():
	
#	$AudioCancel.volume_db = PreloadScript01.bruitages_value
	$AudioCancel.play()
	yield($AudioCancel, "finished")

func play_wooow():
#	$AudioWooow.volume_db = PreloadScript01.bruitages_value
	$AudioWooow.play()
	
func play_wooowdown():
#	$AudioWooowDown.volume_db = PreloadScript01.bruitages_value
	$AudioWooowDown.play()
