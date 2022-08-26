extends Node2D
export (Array) var portraits

enum { PRE_GAME, SILENCE, CHATTER1, CHATTER2, END_GAME }
var state = PRE_GAME

var game_aborted = false

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
	player1.position = Vector2(74, 108)
	player1.scale = Vector2(1, 1)
	player1.connect("energy_changed", get_node("UI/Left"), "set_energy_level")

	player2.player_number = Player.TWO
	player2.position = Vector2(227, 108)
	player2.scale = Vector2(-1, 1)
	player2.connect("energy_changed", get_node("UI/Right"), "set_energy_level")

	portrait_left.texture = portraits[player1_portrait_index]
	portrait_right.texture = portraits[1 - player1_portrait_index]

	# wait, display Fight.tscn, wait again, remove it

	$Timer.start(2)
	yield($Timer, "timeout")
	var fight = preload("res://SCENES/Fight.tscn").instance()
	add_child(fight)
	$Timer.start(2)
	yield($Timer, "timeout")
	fight.queue_free()

	# start gameplay

	state = SILENCE
	player1.start()
	player2.start()

# The first time a player takes a hit, the neighbors start to complain.
#
func somebody_took_a_hit(_damage):
	if state == SILENCE:
		$Commentaires_des_voisins_01.play()
		state = CHATTER1

# When the first stream of complaints finishes, the second stream begins and
# loops.
#
func initial_chatter_finished():
	if state == CHATTER1:
		$Commentaires_des_voisins_02.play()
		state = CHATTER2

func _input(event):
	if PreloadScript01.handle_input_event(event):
		return

	if (state > PRE_GAME and state < END_GAME
		and event.is_action_pressed("ui_cancel")):
		game_aborted = true
		var prev_state = state
		play_cancel()
		stop_game()
		$Music/Bernard.stop()
		if prev_state > SILENCE and AudioServer.get_bus_volume_db(1) > -69:
			$Tout_de_meme.play()
			yield($Tout_de_meme, "finished")
		$TransitionScreen.transition()

func play_cancel():
#	$AudioCancel.volume_db = PreloadScript01.bruitages_value
	$AudioCancel.play()

func stop_game():
	state = END_GAME
	$Commentaires_des_voisins_01.stop()
	$Commentaires_des_voisins_02.stop()

func _on_TransitionScreen_transitioned():
	var start_screen = preload("res://SCENES/Start_Screen.tscn")
	var win_screen = preload("res://SCENES/Win_Screen.tscn")
	var _err
	if game_aborted:
		_err = get_tree().change_scene_to(start_screen)
	else:
		_err = get_tree().change_scene_to(win_screen)

func _on_moulue_ko():
	if CharacterSelectionManager.player1 == "Moulue":
		PreloadScript01.winner = PreloadScript01.COUILLU_RIGHT
	else:
		PreloadScript01.winner = PreloadScript01.COUILLU_LEFT
	game_over()

func _on_couillu_ko():
	if CharacterSelectionManager.player1 == "Moulue":
		PreloadScript01.winner = PreloadScript01.MOULUE_LEFT
	else:
		PreloadScript01.winner = PreloadScript01.MOULUE_RIGHT
	game_over()

func game_over():
	stop_game()
	var ko = preload("res://SCENES/Ko.tscn").instance()
	add_child(ko)
	$Timer.start(2)
	yield($Timer, "timeout")
	ko.queue_free()
	$Timer.start(1)
	yield($Timer, "timeout")
	$Music/Bernard.stop()
	$TransitionScreen.transition()
