extends Node2D



func _ready() -> void:
	pass
	
func _input(event):
#	if Input.is_action_just_pressed("P1_x") or Input.is_action_just_pressed("P2_x"):
	if event is InputEventKey and event.pressed or InputEventJoypadButton and event.pressed:
		play_cancel()
		$TransitionScreen.transition()

func _on_TransitionScreen_transitioned() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://SCENES/Start_Screen.tscn")

func play_cancel():
	$AudioCancel.volume_db = PreloadScript01.bruitages_value
	$AudioCancel.play()
	yield($AudioCancel, "finished")
