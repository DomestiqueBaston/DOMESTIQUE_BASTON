extends Node2D

var baston = "res://SCENES/BASTON.tscn"
var retour = "res://SCENES/Start_Screen.tscn"
var moulue = "res://SCENES/Moulue_cds.tscn"
var couillu = "res://SCENES/Couillu_cds.tscn"
var choice = ""
var moulue_alpha = 0.0
var couillu_alpha = 0.0

func _input(_event):
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left"):
		if $AnimatedSprite.animation == "C_M":
			$AnimatedSprite.play("M_C")
		else:
			$AnimatedSprite.play("C_M")
		play_slide()
		var tmp = CharacterSelectionManager.player
		CharacterSelectionManager.player = CharacterSelectionManager.opponent
		CharacterSelectionManager.opponent = tmp
			
	elif Input.is_action_just_pressed("ui_a"):
		choice = baston
		play_validation()
		MusicController.stop_music()
		$TransitionScreen.transition()
		
	elif Input.is_action_just_pressed("ui_b"):
		if couillu_alpha == 0.0:
			couillu_alpha = 1.0
			play_validation()
		else:
			couillu_alpha = 0.0
			play_cancel()
		$Couillu_cds.modulate.a = couillu_alpha
		
	elif Input.is_action_just_pressed("ui_y"):
		if moulue_alpha == 0.0:
			moulue_alpha = 1.0
			play_validation()
		else:
			moulue_alpha = 0.0
			play_cancel()
		$Moulue_cds.modulate.a = moulue_alpha
	
	elif Input.is_action_just_pressed("ui_x"):
		choice = retour
		play_cancel()
		$TransitionScreen.transition()

func _on_TransitionScreen_transitioned():
# warning-ignore:return_value_discarded
	get_tree().change_scene(choice)
	
func play_validation():
	$AudioValid.volume_db = PreloadScript01.bruitages_value
	$AudioValid.play()
	
func play_cancel():
	$AudioCancel.volume_db = PreloadScript01.bruitages_value
	$AudioCancel.play()
	yield($AudioCancel, "finished")
	
func play_slide():
	$AudioSlide.volume_db = PreloadScript01.bruitages_value
	$AudioSlide.play()
	
