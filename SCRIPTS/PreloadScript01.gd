extends Node2D


#Strat Screen variables
var current_pos := 0
var previous_pos := 0
var current_node := "0"
var previous_node := "3"

#colors!
const white = Color(1,1,1,0)
const black = Color(0.45,0.5,0.5,1)
const violet = Color(1,1,1,1)
const half = Color(1,1,1,0.5)

#Sound levels
const more_than_full_level: float = 7.5
const normal_level: float = 0.0
const half_level: float = -7.5
const no_sound_level: float = -80.0

#Option Screen variables
var commentaires_value: float = 0.0
var bruitages_value: float = 0.0
var musique_value: float = 0.0

var commentaires := 2
var bruitages := 2
var musique := 2

#full screen
var truth = true
	

func _input(_event):
	if (Input.is_action_just_pressed('full_screen')):
		OS.window_fullscreen = truth
		truth = !truth