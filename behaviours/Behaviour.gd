class_name Behaviour
extends Node

var normalized_directions = [
		Vector2.RIGHT.normalized(), # East
		Vector2(1, 1).normalized(), # South East
		Vector2.DOWN.normalized(), # South
		Vector2(-1, 1).normalized(), # South West
		Vector2.LEFT.normalized(), # West
		Vector2(-1, -1).normalized(), # North West
		Vector2.UP.normalized(), # North
		Vector2(1, -1).normalized() # North East
	]


func update_context_maps(interest_map: Array, danger_map: Array, strength: float):
	_update_interest_map(interest_map, strength)
	_update_danger_map(danger_map, strength)

func _update_interest_map(interest_map: Array, _strenght: float):
	return interest_map

func _update_danger_map(danger_map: Array, _strenght: float):
	return danger_map


