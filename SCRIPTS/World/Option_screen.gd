extends Control


# Navigation
var previous_vpos := 0
var current_vpos := 0
var previous_hpos := 0
var current_hpos := 0

var previous_node := ""
var current_node := "0_0"

var line_name = ""



func _ready():
	get_node("0_" + str(SoundLevels.commentaires)).modulate = SoundLevels.violet
	if get_node("0_0").modulate == Color(1,1,1):
		get_node("0_0").modulate = SoundLevels.black
	else:
		get_node("0_0").modulate = SoundLevels.half
	get_node("1_" + str(SoundLevels.bruitages)).modulate = SoundLevels.violet
	get_node("2_" + str(SoundLevels.musique)).modulate = SoundLevels.violet

func _physics_process(_delta):
	if (Input.is_action_just_pressed("ui_down")):
		previous_vpos = current_vpos
		check_previous_boundaries()
		current_vpos += 1
		check_current_boundaries()
		previous_node = str(previous_vpos) + "_" + str(current_hpos)
		current_node = str(current_vpos) + "_" + str(current_hpos)
		turn_on_off()

	elif (Input.is_action_just_pressed("ui_up")):
		previous_vpos = current_vpos
		check_previous_boundaries()
		current_vpos -= 1
		check_current_boundaries()
		previous_node = str(previous_vpos) + "_" + str(current_hpos)
		current_node = str(current_vpos) + "_" + str(current_hpos)
		turn_on_off()

	elif (Input.is_action_just_pressed("ui_right")):
		previous_hpos = current_hpos
		check_previous_boundaries()
		current_hpos += 1
		check_current_boundaries()
		previous_node = str(current_vpos) + "_" + str(previous_hpos)
		current_node = str(current_vpos) + "_" + str(current_hpos)
		turn_on_off()

	elif (Input.is_action_just_pressed("ui_left")):
		previous_hpos = current_hpos
		check_previous_boundaries()
		current_hpos -= 1
		check_current_boundaries()
		previous_node = str(current_vpos) + "_" + str(previous_hpos)
		current_node = str(current_vpos) + "_" + str(current_hpos)
		turn_on_off()

	elif (Input.is_action_just_pressed("ui_a")):
		validation()
	
	elif (Input.is_action_just_pressed("ui_x")):
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
		get_node(current_node).modulate = SoundLevels.black
		if current_vpos == 0:
			get_node("0_" + str(SoundLevels.commentaires)).modulate = SoundLevels.white
			SoundLevels.commentaires = current_hpos
			line_name = "commentaires_value"
			change_sound_level()
		elif current_vpos == 1:
			get_node("1_" + str(SoundLevels.bruitages)).modulate = SoundLevels.white
			SoundLevels.bruitages = current_hpos
			line_name = "bruitages_value"
			change_sound_level()
		else:
			get_node("2_" + str(SoundLevels.musique)).modulate = SoundLevels.white
			SoundLevels.musique = current_hpos
			line_name = "musique_value"
			change_sound_level()
			get_node('/root/MusicController/Music').volume_db = SoundLevels.musique_value
			
# Cursor color management
func turn_on_off():
	if get_node(previous_node).modulate.a == 1 and get_node(current_node).modulate.a == 1:
		get_node(previous_node).modulate = SoundLevels.violet
		get_node(current_node).modulate = SoundLevels.black
	elif get_node(previous_node).modulate.a == 1:
		get_node(previous_node).modulate = SoundLevels.violet
		get_node(current_node).modulate = SoundLevels.half
	elif get_node(current_node).modulate.a == 1:
		get_node(current_node).modulate = SoundLevels.black
		get_node(previous_node).modulate = SoundLevels.white
	else:
		get_node(previous_node).modulate = SoundLevels.white
		get_node(current_node).modulate = SoundLevels.half

func _on_TransitionScreen_transitioned():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SCENES/Start_Screen.tscn")
	
func change_sound_level():
	if current_hpos == 0:
		SoundLevels.set(line_name, SoundLevels.no_sound_level)
	elif current_hpos == 1:
		SoundLevels.set(line_name, SoundLevels.half_level)
	elif current_hpos == 2:
		SoundLevels.set(line_name, SoundLevels.normal_level)
	else:
		SoundLevels.set(line_name, SoundLevels.more_than_full_level)
		
