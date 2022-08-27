extends Node2D

# left edge of mask (position when energy is 0)
const POS0 = 96.5

# size of mask in pixels
const SIZE = 95

onready var energy_mask = get_node("Frame_left/Energy_mask_left")
onready var flasher = get_node("Frame_left/Flasher")

func set_energy_level(energy):
	energy_mask.position.x = POS0 + round(energy * SIZE)

func flash_energy_bar():
	flasher.play("Flash")
