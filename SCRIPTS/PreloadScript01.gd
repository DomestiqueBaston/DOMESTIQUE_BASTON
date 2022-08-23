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

#winners
enum { MOULUE_LEFT, MOULUE_RIGHT, COUILLU_LEFT, COUILLU_RIGHT }
var winner = MOULUE_LEFT

##
## Handles input events common to all scene trees. Returns true if the event
## was handled, false if not.
##
func handle_input_event(event):
	if event.is_action_pressed('full_screen'):
		OS.window_fullscreen = !OS.window_fullscreen
		return true
	return false

##
## Returns true if the given event is a key or button press, false if not.
## Modifier keypresses (ALT, CTRL, SHIFT, META) are ignored.
##
func is_key_or_button_press(event):
	if event is InputEventJoypadButton:
		return event.pressed
	if event is InputEventKey:
		return event.pressed and not event.scancode in [ KEY_ALT, KEY_CONTROL, KEY_SHIFT, KEY_META ]
	return false
