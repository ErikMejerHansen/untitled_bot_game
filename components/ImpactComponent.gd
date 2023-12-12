class_name ImpactComponent
extends Node

signal impact(push_back: Vector2, position: Vector2)

@export var impact_force = 1000

# Called when the node enters the scene tree for the first time.
func hit(bullet: Bullet):
	var p = get_parent()
	var push_back = Vector2.from_angle(bullet.rotation)
	var pos = bullet.global_position - p.global_position
	
	if p is RigidBody2D:
		p.apply_impulse(push_back * impact_force, pos)
	else:
		impact.emit(push_back, pos)
