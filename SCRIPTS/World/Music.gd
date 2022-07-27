extends Node

var music_clip_start : AudioStream = load("res://ASSETS/SOUNDS/MUSIC/START.wav")
var music_clip_loop : AudioStream = load("res://ASSETS/SOUNDS/MUSIC/LOOP.wav")

func _ready():
	whole_music()
	pass

func whole_music():
	play(music_clip_start)
	yield($Bernard, "finished")
	play(music_clip_loop)

func play(clip: AudioStream):
	$Bernard.stream = clip
	$Bernard.volume_db = PreloadScript01.musique_value
	$Bernard.play()


