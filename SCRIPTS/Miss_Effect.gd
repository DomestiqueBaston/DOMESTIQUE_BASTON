extends Node2D

func play_and_delete():
	$AnimationPlayer.play("Miss_Effect")

func _on_animation_finished(_anim_name):
	queue_free()