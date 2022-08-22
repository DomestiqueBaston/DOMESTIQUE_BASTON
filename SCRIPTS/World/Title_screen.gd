extends Node2D

func _ready():
	randomize()
	MusicController.play_music()
#	$Title/AudioStreamPlayer.volume_db = PreloadScript01.bruitages_value

func _input(event):
	if event is InputEventKey and event.pressed:
		if (Input.is_key_pressed(KEY_ALT)):
			pass
		elif (Input.is_key_pressed(KEY_ENTER)):
			pass
		else:
			set_process_input(false)
			play_validation()
			$TransitionScreen.transition()
	elif event is InputEventJoypadButton and event.pressed:
		play_validation()
		$TransitionScreen.transition()

func _on_TransitionScreen_transitioned():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SCENES/Start_Screen.tscn")

func play_validation():
#	$AudioValid.volume_db = PreloadScript01.bruitages_value
	$AudioValid.play()
