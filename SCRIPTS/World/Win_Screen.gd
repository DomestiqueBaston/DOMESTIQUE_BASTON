extends Node2D

func _ready():
	match PreloadScript01.winner:
		PreloadScript01.MOULUE_LEFT:
			$Moulue_Win_left.modulate.a = 1.0
			$Moulue_Sound.play()
		PreloadScript01.MOULUE_RIGHT:
			$Moulue_Win_right.modulate.a = 1.0
			$Moulue_Sound.play()
		PreloadScript01.COUILLU_LEFT:
			$Couillu_Win_left.modulate.a = 1.0
			$Couillu_Sound.play()
		PreloadScript01.COUILLU_RIGHT:
			$Couillu_Win_right.modulate.a = 1.0
			$Couillu_Sound.play()

func _input(event):
	if PreloadScript01.handle_input_event(event):
		return
	elif PreloadScript01.is_key_or_button_press(event):
		var start_screen = preload("res://SCENES/Start_Screen.tscn")
		var _err = get_tree().change_scene_to(start_screen)
