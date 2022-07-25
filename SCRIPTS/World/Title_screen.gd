extends Node2D


func _ready():
	MusicController.play_music()

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_a"):
		$TransitionScreen.transition()
		
func _on_TransitionScreen_transitioned():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SCENES/Start_Screen.tscn")
