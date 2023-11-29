class_name ImpactComponent
extends Node


# Called when the node enters the scene tree for the first time.
func hit(location: Vector2):
	var parent: RigidBody2D = get_parent()
	# This is bad
	parent.apply_impulse(Vector2(1,0).rotated(location.angle()) * 400, location)
