extends Node2D
export (Array) var portraits

func _ready():
	var portrait_left = get_node("UI/Left/Portrait_Left")
	var portrait_right = get_node("UI/Right/Portrait_Right")
	var player1
	var player2
	var player1_portrait_index

	if CharacterSelectionManager.player1 == "Moulue":
		player1 = $Moulue
		player2 = $Couillu
		player1_portrait_index = 0
	else:
		player1 = $Couillu
		player2 = $Moulue
		player1_portrait_index = 1
	
	player1.player_number = Player.ONE
	player1.position = Vector2(49, 108)
	player1.scale = Vector2(1, 1)
	player2.player_number = Player.TWO
	player2.position = Vector2(232, 108)
	player2.scale = Vector2(-1, 1)
	portrait_left.texture = portraits[player1_portrait_index]
	portrait_right.texture = portraits[1 - player1_portrait_index]
	
	
	
# If it is very boring to be so long to quit, just get the "get_tree().quit()" back on!

func _input(event):
	if event.is_action_pressed("ui_cancel"):
#		get_tree().quit()
		play_cancel()
		$Music/Bernard.stop()
		yield($AudioCancel, "finished")
		MusicController.play_music()
		$TransitionScreen.transition()

func play_cancel():
	$AudioCancel.volume_db = PreloadScript01.bruitages_value
	$AudioCancel.play()

func _on_TransitionScreen_transitioned():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SCENES/Start_Screen.tscn")
