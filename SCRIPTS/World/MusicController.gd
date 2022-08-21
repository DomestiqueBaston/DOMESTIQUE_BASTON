extends Node


var main_music = load("res://ASSETS/SOUNDS/MUSIC/MAIN.wav")


func _ready():
	pass
	
func stop_music():
	$Music.stream = main_music
	$Music.stop()
	
func play_music():
	$Music.stream = main_music
#	$Music.volume_db = PreloadScript01.musique_value
	$Music.play()

