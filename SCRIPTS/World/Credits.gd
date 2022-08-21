extends Node2D



func _ready() -> void:
	pass
	
func _input(event):

	if event is InputEventJoypadButton and event.pressed:
		play_cancel()
		$TransitionScreen.transition()
	elif event is InputEventKey and event.pressed:
		if (Input.is_key_pressed(KEY_ALT)):
			pass
		elif (Input.is_key_pressed(KEY_ENTER)):
			pass
		else:
			set_process_input(false)
			play_cancel()
			$TransitionScreen.transition()

func _on_TransitionScreen_transitioned() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SCENES/Start_Screen.tscn")

func play_cancel():
#	$AudioCancel.volume_db = PreloadScript01.bruitages_value
	$AudioCancel.play()
	yield($AudioCancel, "finished")
