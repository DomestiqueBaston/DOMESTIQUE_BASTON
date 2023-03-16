# This script is based on the Credit.gd (please remove this comment once read)

extends Node2D

var ignore_input = false
var current_page = 0
const page_count = 6

func _ready() -> void:
	pass
	
func _input(event):
	if PreloadScript01.handle_input_event(event) or ignore_input:
		return
	elif PreloadScript01.is_key_or_button_press(event):
		if event.is_action_pressed("ui_cancel"):
			ignore_input = true
			play_cancel()
			$TransitionScreen.transition()
		else:
			play_validation()
			next_page()

func next_page():
	current_page += 1
	if current_page == page_count:
		ignore_input = true
		$TransitionScreen.transition()
	else:
		get_node("Tuto_0%d" % current_page).visible = false
		get_node("Tuto_0%d" % (current_page + 1)).visible = true

func _on_TransitionScreen_transitioned() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SCENES/Start_Screen.tscn")

func play_cancel():
#	$AudioCancel.volume_db = PreloadScript01.bruitages_value
	$AudioCancel.play()
	yield($AudioCancel, "finished")
	
func play_validation():
#	$AudioValidation.volume_db = PreloadScript01.bruitages_value
	$AudioValidation.play()
	yield($AudioValidation, "finished")
