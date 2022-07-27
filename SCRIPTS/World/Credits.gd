extends Node2D



func _ready() -> void:
	pass
	
func _input(_event):
	if Input.is_action_just_pressed("ui_x"):
		$TransitionScreen.transition()


func _on_TransitionScreen_transitioned() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SCENES/Start_Screen.tscn")
