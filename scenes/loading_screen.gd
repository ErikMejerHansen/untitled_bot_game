extends Node2D

@onready var animation_player = $CanvasLayer/AnimationPlayer

func fade_out():
	animation_player.play("fade_to_black")

func fade_in():
	animation_player.play_backwards("fade_to_black")
