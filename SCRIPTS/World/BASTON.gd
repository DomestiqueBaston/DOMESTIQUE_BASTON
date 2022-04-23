extends Node2D

onready var gamePlayer = CharacterSelectionManager.player.instance()
onready var gameOpponent = CharacterSelectionManager.opponent.instance()

func _ready():
	print(gameOpponent.name, " ", gameOpponent.position, " ", gamePlayer.name)
	SpawnCharacters()

func _physics_process(_delta):
#	$TransitionScreen.transition()
	if Input.is_action_pressed("ui_a") && Input.is_action_pressed("ui_b") && Input.is_action_pressed("ui_x") && Input.is_action_pressed("ui_y"):
		get_tree().quit()

func SpawnCharacters():
	gamePlayer.position = Vector2(49, 108)
	gamePlayer.set_script(CharacterSelectionManager.playerScript)
	call_deferred("add_child", gamePlayer)
	
	gameOpponent.position = Vector2(232, 108)
	gameOpponent.set_script(CharacterSelectionManager.aiScript)
	call_deferred("add_child", gameOpponent)
	
