class_name ImpactComponent
extends Node

@export var impact_force = 1000
# Called when the node enters the scene tree for the first time.
func hit(bullet: Bullet):
	var p = get_parent() as RigidBody2D

	var push_back = Vector2.from_angle(bullet.rotation)
	var pos = bullet.global_position - p.global_position
	p.apply_impulse(push_back * impact_force, pos)
	
