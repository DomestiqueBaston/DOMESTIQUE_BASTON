extends Control


var reglons = "res://SCENES/Cornillaud.tscn"
var changer = "res://SCENES/Option_Screen.tscn"
var chasse = "res://SCENES/Credits.tscn"
var choice = ""


func _ready():
	get_node(PreloadScript01.previous_node).modulate.a = 0
	get_node(PreloadScript01.current_node).modulate.a = 1

func _input(event):
	if event.is_action_pressed('P1_down') or event.is_action_pressed('P2_down'):
		PreloadScript01.previous_pos = PreloadScript01.current_pos
		check_previous_boundaries()
		PreloadScript01.current_pos += 1
		check_current_boundaries()
		PreloadScript01.previous_node = str(PreloadScript01.previous_pos)
		PreloadScript01.current_node = str(PreloadScript01.current_pos)
		play_wooowdown()
		turn_on_off()

	elif event.is_action_pressed('P1_up') or event.is_action_pressed('P2_up'):
		PreloadScript01.previous_pos = PreloadScript01.current_pos
		check_previous_boundaries()
		PreloadScript01.current_pos -= 1
		check_current_boundaries()
		PreloadScript01.previous_node = str(PreloadScript01.previous_pos)
		PreloadScript01.current_node = str(PreloadScript01.current_pos)
		play_wooow()
		turn_on_off()
		
	elif event.is_action_pressed('P1_a') or event.is_action_pressed('P2_a'):
		if PreloadScript01.current_pos == 0:
			choice = reglons
			PreloadScript01.current_node = "0"
			play_valid()
		elif PreloadScript01.current_pos == 1:
			choice = changer
			PreloadScript01.current_node = "1"
			play_valid()
		elif PreloadScript01.current_pos == 2:
			choice = chasse
			PreloadScript01.current_node = "2"
			play_valid()
		else:
#			$AudioCancel.volume_db = PreloadScript01.bruitages_value
			$AudioCancel.play()
			yield($AudioCancel, "finished")
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

func play_valid():
#	$AudioValid.volume_db = PreloadScript01.bruitages_value
	$AudioValid.play()
	
func play_wooow():
#	$AudioWooow.volume_db = PreloadScript01.bruitages_value
	$AudioWooow.play()
	
func play_wooowdown():
#	$AudioWooowDown.volume_db = PreloadScript01.bruitages_value
	$AudioWooowDown.play()
