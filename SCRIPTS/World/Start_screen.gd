extends Control


var reglons = "res://SCENES/Cornillaud.tscn"
var changer = "res://SCENES/Option_Screen.tscn"
var chasse = "res://SCENES/Credits.tscn"
var choice = ""


func _ready():
	get_node(PreloadScript01.previous_node).modulate.a = 0
	get_node(PreloadScript01.current_node).modulate.a = 1

func _input(_event):
	if (Input.is_action_just_pressed("ui_down")):
		PreloadScript01.previous_pos = PreloadScript01.current_pos
		check_previous_boundaries()
		PreloadScript01.current_pos += 1
		check_current_boundaries()
		PreloadScript01.previous_node = str(PreloadScript01.previous_pos)
		PreloadScript01.current_node = str(PreloadScript01.current_pos)
		turn_on_off()

	elif (Input.is_action_just_pressed("ui_up")):
		PreloadScript01.previous_pos = PreloadScript01.current_pos
		check_previous_boundaries()
		PreloadScript01.current_pos -= 1
		check_current_boundaries()
		PreloadScript01.previous_node = str(PreloadScript01.previous_pos)
		PreloadScript01.current_node = str(PreloadScript01.current_pos)
		turn_on_off()
		
	elif (Input.is_action_just_pressed("ui_a")):
		if PreloadScript01.current_pos == 0:
			choice = reglons
			PreloadScript01.current_node = "0"
			
		elif PreloadScript01.current_pos == 1:
			choice = changer
			PreloadScript01.current_node = "1"
			
		elif PreloadScript01.current_pos == 2:
			choice = chasse
			PreloadScript01.current_node = "2"
			
		else:
			get_tree().quit()
		get_node("../TransitionScreen").transition()

func check_current_boundaries():
	if PreloadScript01.current_pos < 0:
		PreloadScript01.current_pos = 3
	elif PreloadScript01.current_pos > 3:
		PreloadScript01.current_pos = 0

func check_previous_boundaries():
	if PreloadScript01.previous_pos < 0:
		PreloadScript01.previous_pos = 3
	elif PreloadScript01.previous_pos > 3:
		PreloadScript01.previous_pos = 0

func turn_on_off():
	get_node(PreloadScript01.previous_node).modulate.a = 0
	get_node(PreloadScript01.current_node).modulate.a = 1

func _on_TransitionScreen_transitioned():
	# warning-ignore:return_value_discarded
	get_tree().change_scene(choice)
