extends Node2D
export (Array) var portraits

func _ready():
	var portraitLeft = get_node("UI/Left/Portrait_Left") 
	var portraitRight = get_node("UI/Right/Portrait_Right") 

	if CharacterSelectionManager.player == "Moulue":
		$Moulue.player_number = Player.PlayerNumber.ONE
		$Moulue.position = Vector2(49, 108)
		$Moulue.scale = Vector2(1, 1)
		$Couillu.player_number = Player.PlayerNumber.TWO
		$Couillu.position = Vector2(232, 108)
		$Couillu.scale = Vector2(-1, 1)
		portraitLeft.texture = portraits[0]
		portraitRight.texture = portraits[1]
	else:
		$Couillu.player_number = Player.PlayerNumber.ONE
		$Couillu.position = Vector2(49, 108)
		$Couillu.scale = Vector2(1, 1)
		$Moulue.player_number = Player.PlayerNumber.TWO
		$Moulue.position = Vector2(232, 108)
		$Moulue.scale = Vector2(-1, 1)
		portraitLeft.texture = portraits[1]
		portraitRight.texture = portraits[0]

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
