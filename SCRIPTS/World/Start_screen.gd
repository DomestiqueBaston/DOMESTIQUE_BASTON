extends Control


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


