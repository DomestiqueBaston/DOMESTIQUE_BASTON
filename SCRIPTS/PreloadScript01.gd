extends Node2D


#Start Screen variables
var current_pos := 0
var previous_pos := 0
var current_node := "0"
var previous_node := "3"

#colors constants!
const WHITE = Color(1,1,1,0)
const BLACK = Color(0.45,0.5,0.5,1)
const VIOLET = Color(1,1,1,1)
const HALF = Color(1,0.55,0.84,0.5)

#Sound levels constants
const MORE_THAN_FULL_LEVEL: float = 7.5
const NORMAL_LEVEL: float = 0.0
const HALF_LEVEL: float = -7.5
const NO_SOUND_LEVEL: float = -80.0

#Option Screen variables
#var commentaires_value = NORMAL_LEVEL
#var bruitages_value = NORMAL_LEVEL
#var musique_value = NORMAL_LEVEL

#Option Screen default cursor position
var commentaires := 2
var bruitages := 2
var musique := 2

#full screen
var truth = true

#winners
var moulue_win_left = false
var moulue_win_right = false
var couillu_win_left = false
var couillu_win_right = false
	

func _input(_event):
	if (Input.is_action_just_pressed('full_screen')):
		OS.window_fullscreen = truth
		truth = !truth
