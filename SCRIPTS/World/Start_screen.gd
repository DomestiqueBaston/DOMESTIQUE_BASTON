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
		previous_pos_to_previous_node()
		current_pos_to_current_node()
		turn_on_off()

	elif (Input.is_action_just_pressed("ui_up")):
		previous_pos = current_pos
		check_previous_boundaries()
		current_pos -= 1
		check_current_boundaries()
		previous_pos_to_previous_node()
		current_pos_to_current_node()
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

func current_pos_to_current_node():
	if current_pos == 0:
		current_node = "Reglons_ON"
	elif current_pos == 1:
		current_node = "Changer_ON"
	elif current_pos == 2:
		current_node = "Pondu_ON"
	else:
		current_node = "Decarrer_ON"


func previous_pos_to_previous_node():
	if previous_pos == 0:
		previous_node = "Reglons_ON"
	elif previous_pos == 1:
		previous_node = "Changer_ON"
	elif previous_pos == 2:
		previous_node = "Pondu_ON"
	else:
		previous_node = "Decarrer_ON"

func turn_on_off():
	get_node(previous_node).modulate = Color(1,1,1,0)
	get_node(current_node).modulate = Color(1,1,1,1)
#	get_node(previous_node).hide()
#	get_node(current_node).show()

