extends Control


var reglons = "res://SCENES/Cornillaud.tscn"
var changer = "res://SCENES/Option_Screen.tscn"
var chasse = "res://SCENES/Credits.tscn"
var choice = ""


var current_pos := 0
var previous_pos := 0
var current_node := "Reglons_ON"
var previous_node := ""


func _ready():
	pass

func _physics_process(_delta):
	if (Input.is_action_just_pressed("ui_down")):
		previous_pos = current_pos
		check_previous_boundaries()
		current_pos += 1
		check_current_boundaries()
		previous_node = str(previous_pos)
		current_node = str(current_pos)
		turn_on_off()

	elif (Input.is_action_just_pressed("ui_up")):
		previous_pos = current_pos
		check_previous_boundaries()
		current_pos -= 1
		check_current_boundaries()
		previous_node = str(previous_pos)
		current_node = str(current_pos)
		turn_on_off()
		
	elif (Input.is_action_just_pressed("ui_a")):
		if current_pos == 0:
			choice = reglons
		elif current_pos == 1:
			choice = changer
		elif current_pos == 2:
			choice = chasse
		else:
			get_tree().quit()
		get_node("../TransitionScreen").transition()

func check_current_boundaries():
	if current_pos < 0:
		current_pos = 3
	elif current_pos > 3:
		current_pos = 0

func check_previous_boundaries():
	if previous_pos < 0:
		previous_pos = 3
	elif previous_pos > 3:
		previous_pos = 0

func turn_on_off():
	get_node(previous_node).modulate.a = 0
	get_node(current_node).modulate.a = 1

func _on_TransitionScreen_transitioned():
	# warning-ignore:return_value_discarded
	get_tree().change_scene(choice)

