extends Node2D


func _ready():
	if PreloadScript01.moulue_win_left == true:
		$Moulue_Win_left.modulate.a = 1.0
		$Moulue_Sound.play()
	elif PreloadScript01.moulue_win_right == true:
		$Moulue_Win_right.modulate.a = 1.0
		$Moulue_Sound.play()
	elif PreloadScript01.couillu_win_left == true:
		$Couillu_Win_left.modulate.a = 1.0
		$Couillu_Sound.play()
	elif PreloadScript01.couillu_win_left == true:
		$Couillu_Win_right.modulate.a = 1.0
		$Couillu_Sound.play()
