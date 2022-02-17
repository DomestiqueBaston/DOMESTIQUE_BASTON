extends Node2D


func _physics_process(_delta):
#	$TransitionScreen.transition()
	if Input.is_action_pressed("ui_a") && Input.is_action_pressed("ui_b") && Input.is_action_pressed("ui_x") && Input.is_action_pressed("ui_y"):
		get_tree().quit()
