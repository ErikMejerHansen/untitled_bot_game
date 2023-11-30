class_name EnemyDrone
extends CharacterBody2D

const DROP_SHADOW_OFFSET = Vector2(120, 275)

func _ready():
	$AnimationPlayer.play("idle")
		

func _draw():
	$DroneShadow.global_position = global_position + DROP_SHADOW_OFFSET.rotated(rotation)
	
	
func _on_die():
	queue_free()
