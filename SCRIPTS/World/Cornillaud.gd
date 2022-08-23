extends Node2D

var baston = "res://SCENES/BASTON.tscn"
var retour = "res://SCENES/Start_Screen.tscn"
var moulue = "res://SCENES/Moulue_cds.tscn"
var couillu = "res://SCENES/Couillu_cds.tscn"
var choice = ""
var moulue_alpha = 0.0
var couillu_alpha = 0.0

func _input(event):
	if PreloadScript01.handle_input_event(event):
		return
		
	elif (event.is_action_pressed('P1_right') or
		  event.is_action_pressed('P1_left') or
		  event.is_action_pressed('P2_right') or
		  event.is_action_pressed('P2_left') or
		  event.is_action_pressed('P1_up') or
		  event.is_action_pressed('P1_down') or
		  event.is_action_pressed('P2_up') or
		  event.is_action_pressed('P2_down')):
		if moulue_alpha == 1.0 or couillu_alpha == 1.0:
			return
		if $AnimatedSprite.animation == "C_M":
			$AnimatedSprite.play("M_C")
			play_counterslide()
		else:
			$AnimatedSprite.play("C_M")
			play_slide()
		CharacterSelectionManager.swap()
			
	elif event.is_action_pressed('P1_a') or event.is_action_pressed('P2_a'):
		choice = baston
		play_validation()
		MusicController.stop_music()
		$TransitionScreen.transition()
		
	elif event.is_action_pressed('P1_y') or event.is_action_pressed('P2_y'):
		if moulue_alpha == 1.0:
			pass
		elif couillu_alpha == 0.0:
			moulue_alpha = 0.0
			couillu_alpha = 1.0
			play_validation()
		elif couillu_alpha == 1.0:
			couillu_alpha = 0.0
			moulue_alpha = 0.0
			play_cancel()
		$Couillu_cds.modulate.a = couillu_alpha
		
	elif event.is_action_pressed('P1_x') or event.is_action_pressed('P2_x'):
		if couillu_alpha == 1.0:
			pass
		elif moulue_alpha == 0.0:
			couillu_alpha = 0.0
			moulue_alpha = 1.0
			play_validation()
		elif moulue_alpha == 1.0:
			moulue_alpha = 0.0
			couillu_alpha = 0.0
			play_cancel()
		$Moulue_cds.modulate.a = moulue_alpha
		
	elif PreloadScript01.is_key_or_button_press(event):
		choice = retour
		play_cancel()
		$TransitionScreen.transition()

func _on_TransitionScreen_transitioned():
# warning-ignore:return_value_discarded
	get_tree().change_scene(choice)
	
func play_validation():
#	$AudioValid.volume_db = PreloadScript01.bruitages_value
	$AudioValid.play()
	
func play_cancel():
#	$AudioCancel.volume_db = PreloadScript01.bruitages_value
	$AudioCancel.play()
	yield($AudioCancel, "finished")
	
func play_slide():
#	$AudioSlide.volume_db = PreloadScript01.bruitages_value
	$AudioSlide.play()
	
func play_counterslide():
#	$AudioCounterSlide.volume_db = PreloadScript01.bruitages_value
	$AudioCounterSlide.play()
