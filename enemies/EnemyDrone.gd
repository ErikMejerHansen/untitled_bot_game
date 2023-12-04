class_name EnemyDrone
extends CharacterBody2D

const DROP_SHADOW_OFFSET = Vector2(-100, -275)

func _ready():
	$AnimationPlayer.play("idle")


func _physics_process(delta):
	$DroneShadow.global_rotation = 0
	$DroneShadow.global_position = global_position - DROP_SHADOW_OFFSET
	
	if randf() > 0.999:
		$AnimationPlayer.play("deploy_guns")
	
func _on_die(_damage_source: Node2D):
	queue_free()
