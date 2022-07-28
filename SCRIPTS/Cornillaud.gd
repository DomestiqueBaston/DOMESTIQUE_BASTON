extends Node2D

var baston = "res://SCENES/BASTON.tscn"
var retour = "res://SCENES/Start_Screen.tscn"
var moulue = "res://SCENES/Moulue_cds.tscn"
var couillu = "res://SCENES/Couillu_cds.tscn"
var choice = ""

func _input(_event):
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left"):
		if $AnimatedSprite.animation == "C_M":
			$AnimatedSprite.play("M_C")
		else:
			$AnimatedSprite.play("C_M")
		var tmp = CharacterSelectionManager.player
		CharacterSelectionManager.player = CharacterSelectionManager.opponent
		CharacterSelectionManager.opponent = tmp
			
	elif Input.is_action_just_pressed("ui_a"):
		choice = baston
		MusicController.stop_music()
		$TransitionScreen.transition()
		
	elif Input.is_action_just_pressed("ui_b"):
		get_tree().change_scene("res://SCENES/Couillu_cds.tscn")
		
	elif Input.is_action_just_pressed("ui_y"):
		get_tree().change_scene("res://SCENES/Moulue_cds.tscn")
	
	elif Input.is_action_just_pressed("ui_x"):
		choice = retour
		$TransitionScreen.transition()

func _on_TransitionScreen_transitioned():
# warning-ignore:return_value_discarded
	get_tree().change_scene(choice)
	
