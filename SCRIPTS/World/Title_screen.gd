extends Node2D


func _ready():
	MusicController.play_music()
	$Title/AudioStreamPlayer.volume_db = SoundLevels.normal_level

func _input(event):
	if event is InputEventKey and event.pressed:
		if (Input.is_key_pressed(KEY_ALT)):
			pass
		elif (Input.is_key_pressed(KEY_ENTER)):
			pass
		else:
			$TransitionScreen.transition()
	elif event is InputEventJoypadButton and event.pressed:
		$TransitionScreen.transition()
		
func _on_TransitionScreen_transitioned():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SCENES/Start_Screen.tscn")

