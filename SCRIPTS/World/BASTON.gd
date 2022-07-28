extends Node2D

onready var gamePlayer = CharacterSelectionManager.player.instance()
onready var gameOpponent = CharacterSelectionManager.opponent.instance()

var playerScript = preload("res://SCRIPTS/Characters/Player1.gd")

export (Array) var portraits

onready var portraitLeft = get_node("UI/Left/Portrait_Left") 
onready var portraitRight = get_node("UI/Right/Portrait_Right") 

func _ready():
	print(gameOpponent.name, " ", gameOpponent.position, " ", gamePlayer.name)
	SetUpScene()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func SetUpScene():
	gamePlayer.position = Vector2(49, 108)
	gamePlayer.set_script(playerScript)
	call_deferred("add_child", gamePlayer)
	
	gameOpponent.position = Vector2(232, 108)
	call_deferred("add_child", gameOpponent)
	
	if(gamePlayer.name == "Moulue"):
		portraitLeft.texture = portraits[0]
		portraitRight.texture = portraits[1]
	elif(gamePlayer.name == "Couillu"):
		portraitLeft.texture = portraits[1]
		portraitRight.texture = portraits[0]
