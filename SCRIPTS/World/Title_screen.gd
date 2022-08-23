extends Node2D

var ignore_input = false

func _ready():
	randomize()
	MusicController.play_music()
#	$Title/AudioStreamPlayer.volume_db = PreloadScript01.bruitages_value

func _input(event):
	if PreloadScript01.handle_input_event(event) or ignore_input:
		return
	elif PreloadScript01.is_key_or_button_press(event):
		ignore_input = true
		play_validation()
		$TransitionScreen.transition()

func _on_TransitionScreen_transitioned():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SCENES/Start_Screen.tscn")

func play_validation():
#	$AudioValid.volume_db = PreloadScript01.bruitages_value
	$AudioValid.play()
