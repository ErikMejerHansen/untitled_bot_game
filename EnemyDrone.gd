class_name EnemyDrone
extends CharacterBody2D


func _ready():
	$AnimationPlayer.play("idle")
		
func _on_die():
	queue_free()
