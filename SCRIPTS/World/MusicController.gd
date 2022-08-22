extends Node

var main_music = load("res://ASSETS/SOUNDS/MUSIC/MAIN.wav")

func stop_music():
	$Music.stop()

func play_music():
	if not $Music.playing:
		$Music.stream = main_music
		#$Music.volume_db = PreloadScript01.musique_value
		$Music.play()
