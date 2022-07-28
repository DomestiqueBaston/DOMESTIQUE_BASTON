extends Node2D
export (Array) var portraits

func _ready():
	var portrait_left = get_node("UI/Left/Portrait_Left")
	var portrait_right = get_node("UI/Right/Portrait_Right")
	var player1
	var player2
	var player1_portrait_index

	if CharacterSelectionManager.player == "Moulue":
		player1 = $Moulue
		player2 = $Couillu
		player1_portrait_index = 0
	else:
		player1 = $Couillu
		player2 = $Moulue
		player1_portrait_index = 1
	
	player1.player_number = Player.PlayerNumber.ONE
	player1.position = Vector2(49, 108)
	player1.scale = Vector2(1, 1)
	player2.player_number = Player.PlayerNumber.TWO
	player2.position = Vector2(232, 108)
	player2.scale = Vector2(-1, 1)
	portrait_left.texture = portraits[player1_portrait_index]
	portrait_right.texture = portraits[1 - player1_portrait_index]

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
