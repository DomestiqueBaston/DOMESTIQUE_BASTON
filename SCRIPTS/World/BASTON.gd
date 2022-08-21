extends Node2D
export (Array) var portraits

enum { PRE_GAME, SILENCE, CHATTER1, CHATTER2, END_GAME }
var state = PRE_GAME

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
	player1.position = Vector2(64, 108)
	player1.scale = Vector2(1, 1)
	player1.connect("energy_changed", get_node("UI/Left"), "set_energy_level")

	player2.player_number = Player.TWO
	player2.position = Vector2(217, 108)
	player2.scale = Vector2(-1, 1)
	player2.connect("energy_changed", get_node("UI/Right"), "set_energy_level")

	portrait_left.texture = portraits[player1_portrait_index]
	portrait_right.texture = portraits[1 - player1_portrait_index]

	# wait 2 seconds, display Fight.tscn, wait 2 seconds, remove it

	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start(2)
	yield(timer, "timeout")
	var fight = preload("res://SCENES/Fight.tscn").instance()
	add_child(fight)
	timer.start(2)
	yield(timer, "timeout")
	fight.queue_free()
	timer.queue_free()

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
	if state > PRE_GAME and state < END_GAME and event.is_action_pressed("ui_cancel"):
		state = END_GAME
		$Commentaires_des_voisins_01.stop()
		$Commentaires_des_voisins_02.stop()
		play_cancel()
		$Tout_de_meme.play()
		$Music/Bernard.stop()
		yield($Tout_de_meme, "finished")
		CharacterSelectionManager.reset()
		MusicController.play_music()
		$TransitionScreen.transition()

func play_cancel():
#	$AudioCancel.volume_db = PreloadScript01.bruitages_value
	$AudioCancel.play()

func _on_TransitionScreen_transitioned():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SCENES/Start_Screen.tscn")
