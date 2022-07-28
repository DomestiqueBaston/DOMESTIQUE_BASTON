extends Node2D

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_b"):
		play_cancel()
		get_tree().change_scene("res://SCENES/Cornillaud.tscn")

func play_cancel():
	$AudioCancel.volume_db = PreloadScript01.bruitages_value
	$AudioCancel.play()
	yield($AudioCancel, "finished")
