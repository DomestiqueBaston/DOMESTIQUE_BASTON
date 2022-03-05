extends Node2D


func _physics_process(_delta):
	if Input.is_action_just_pressed("top_right"):
		get_tree().change_scene("res://SCENES/Cornillaud.tscn")
