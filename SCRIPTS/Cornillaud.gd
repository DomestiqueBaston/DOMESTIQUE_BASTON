extends Node2D


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left"):
		if $AnimatedSprite.animation == "C_M":
			$AnimatedSprite.play("M_C")
		else:
			$AnimatedSprite.play("C_M")
			
	elif Input.is_action_just_pressed("ui_a"):
		MusicController.stop_music()
		$TransitionScreen.transition()
		
	elif Input.is_action_just_pressed("top_right"):
		$TransitionScreen.transition()
		get_tree().change_scene("res://SCENES/Couillu_cds.tscn")
		
	elif Input.is_action_just_pressed("top_left"):
		$TransitionScreen.transition()
		get_tree().change_scene("res://SCENES/Moulue_cds.tscn")
		
func _on_TransitionScreen_transitioned():
	get_tree().change_scene("res://SCENES/BASTON.tscn")
