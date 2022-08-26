extends Node2D

var baston = preload("res://SCENES/BASTON.tscn")
var retour = preload("res://SCENES/Start_Screen.tscn")
var next_screen
var cds
var ignore_input = false

func _input(event):
	if PreloadScript01.handle_input_event(event) or ignore_input:
		return
		
	elif (event.is_action_pressed('P1_right') or
		  event.is_action_pressed('P1_left') or
		  event.is_action_pressed('P2_right') or
		  event.is_action_pressed('P2_left') or
		  event.is_action_pressed('P1_up') or
		  event.is_action_pressed('P1_down') or
		  event.is_action_pressed('P2_up') or
		  event.is_action_pressed('P2_down')):
		if cds:
			return
		if $AnimatedSprite.animation == "C_M":
			$AnimatedSprite.play("M_C")
			play_counterslide()
		else:
			$AnimatedSprite.play("C_M")
			play_slide()
		CharacterSelectionManager.swap()
			
	elif event.is_action_pressed('P1_a') or event.is_action_pressed('P2_a'):
		ignore_input = true
		next_screen = baston
		play_validation()
		MusicController.stop_music()
		$TransitionScreen.transition()
		
	elif event.is_action_pressed('P1_x') or event.is_action_pressed('P2_x'):
		toggle_cds(CharacterSelectionManager.player1)
		
	elif event.is_action_pressed('P1_y') or event.is_action_pressed('P2_y'):
		toggle_cds(CharacterSelectionManager.player2)
		
	elif PreloadScript01.is_key_or_button_press(event):
		ignore_input = true
		next_screen = retour
		play_cancel()
		$TransitionScreen.transition()

func toggle_cds(who):
	if not cds:
		cds = who
		play_validation()
		$Moulue_cds.modulate.a = 1 if who == "Moulue" else 0
		$Couillu_cds.modulate.a = 1 if who == "Couillu" else 0
	elif cds == who:
		cds = null
		play_cancel()
		$Moulue_cds.modulate.a = 0
		$Couillu_cds.modulate.a = 0

func _on_TransitionScreen_transitioned():
	var _err = get_tree().change_scene_to(next_screen)

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
