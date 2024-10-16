extends Node2D

# left edge of mask (position when energy is 0)
const POS0 = 96.5

# size of mask in pixels
const SIZE = 95

onready var energy_mask = get_node("Frame_right/Energy_mask_right")
onready var flasher = get_node("Frame_right/Flasher")

func set_energy_level(energy):
	energy_mask.position.x = POS0 + round(energy * SIZE)
	flasher.play("Flash")
