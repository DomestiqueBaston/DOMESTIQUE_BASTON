extends Node2D
export (Array) var portraits

func _ready():

	# set up the two players, one on the left and one on the right

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
	player1.position = Vector2(79, 108)
	player1.scale = Vector2(1, 1)
	player1.connect("energy_changed", get_node("UI/Left"), "set_energy_level")

	player2.player_number = Player.TWO
	player2.position = Vector2(202, 108)
	player2.scale = Vector2(-1, 1)
	player2.connect("energy_changed", get_node("UI/Right"), "set_energy_level")

	portrait_left.texture = portraits[player1_portrait_index]
	portrait_right.texture = portraits[1 - player1_portrait_index]

	# wait one second, display Fight.tscn, wait another second, remove it

	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start(1)
	yield(timer, "timeout")
	var fight = preload("res://SCENES/Fight.tscn").instance()
	add_child(fight)
	timer.start(1)
	yield(timer, "timeout")
	$Commentaires_des_voisins.play()
	fight.queue_free()
	timer.queue_free()
	
	# release players

	player1.start()
	player2.start()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
#		play_cancel() #just for "fun" while coding
		$Commentaires_des_voisins.stop() #just in case and for "fun" while coding
#		$Music/Bernard.stop() #just for "fun" while coding
#		yield($AudioCancel, "finished") #just for "fun" while coding
#		get_tree().quit()
###		to get the next 7 lines back, remove the 5 previous lines
		play_cancel()
		$Commentaires_des_voisins.stop() #just in case
		$Music/Bernard.stop()
		yield($AudioCancel, "finished")
		CharacterSelectionManager.reset()
		MusicController.play_music()
		$TransitionScreen.transition()

func play_cancel():
#	$AudioCancel.volume_db = PreloadScript01.bruitages_value
	$AudioCancel.play()

func _on_TransitionScreen_transitioned():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SCENES/Start_Screen.tscn")
