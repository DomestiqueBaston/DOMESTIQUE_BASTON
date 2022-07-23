extends Control

# Navigation
var previous_vpos := 0
var current_vpos := 0
var previous_hpos := 0
var current_hpos := 0

var current_node := "0_0"
var previous_node := ""

#status
var commentaires := 2
var bruitages := 2
var musique := 2

var old_node := ""

func _ready():
	pass

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
		if current_vpos == 0:
			if current_hpos == 0:
				if get_node(current_node).modulate.a != 1:
					get_node("0_" + str(commentaires)).modulate.a = 0
					get_node(current_node).modulate.a = 1
					commentaires = 0
					
			elif current_hpos == 1:
				if get_node(current_node).modulate.a != 1:
					get_node("0_" + str(commentaires)).modulate.a = 0
					get_node(current_node).modulate.a = 1
					commentaires = 1
					
			elif current_hpos == 2:
				if get_node(current_node).modulate.a != 1:
					get_node("0_" + str(commentaires)).modulate.a = 0
					get_node(current_node).modulate.a = 1
					commentaires = 2
					
			elif current_hpos == 3:
				if get_node(current_node).modulate.a != 1:
					get_node(current_node).modulate.a = 1
					get_node("0_" + str(commentaires)).modulate.a = 0
					commentaires = 3
					
		elif current_vpos == 1:
			if current_hpos == 0:
				if get_node(current_node).modulate.a != 1:
					get_node("1_" + str(bruitages)).modulate.a = 0
					get_node(current_node).modulate.a = 1
					bruitages = 0
					
			elif current_hpos == 1:
				if get_node(current_node).modulate.a != 1:
					get_node("1_" + str(bruitages)).modulate.a = 0
					get_node(current_node).modulate.a = 1
					bruitages = 1
					
			elif current_hpos == 2:
				if get_node(current_node).modulate.a != 1:
					get_node("1_" + str(bruitages)).modulate.a = 0
					get_node(current_node).modulate.a = 1
					bruitages = 2
					
			elif current_hpos == 3:
				if get_node(current_node).modulate.a != 1:
					get_node(current_node).modulate.a = 1
					get_node("1_" + str(bruitages)).modulate.a = 0
					bruitages = 3
					
		elif current_vpos == 2:
			if current_hpos == 0:
				if get_node(current_node).modulate.a != 1:
					get_node("2_" + str(musique)).modulate.a = 0
					get_node(current_node).modulate.a = 1
					musique = 0
					
			elif current_hpos == 1:
				if get_node(current_node).modulate.a != 1:
					get_node("2_" + str(musique)).modulate.a = 0
					get_node(current_node).modulate.a = 1
					musique = 1
					
			elif current_hpos == 2:
				if get_node(current_node).modulate.a != 1:
					get_node("2_" + str(musique)).modulate.a = 0
					get_node(current_node).modulate.a = 1
					musique = 2
					
			elif current_hpos == 3:
				if get_node(current_node).modulate.a != 1:
					get_node(current_node).modulate.a = 1
					get_node("2_" + str(musique)).modulate.a = 0
					musique = 3
				
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

func turn_on_off():
	if get_node(previous_node).modulate.a == 1 and get_node(current_node).modulate.a == 1:
		pass
	elif get_node(previous_node).modulate.a == 1:
		get_node(current_node).modulate.a = 0.5
	elif get_node(current_node).modulate.a == 1:
		get_node(previous_node).modulate.a = 0
	else:
		get_node(previous_node).modulate.a = 0
		get_node(current_node).modulate.a = 0.5
