class_name GuardStartingPointBehaviour
extends Behaviour


var starting_point: Vector2
var parent: Node2D
var max_range: float

func _ready():
	parent = get_parent()
	
	max_range = parent.max_range
	starting_point = parent.global_position

func _update_interest_map(interest_map:Array, strenght: float):
	var direction_to_target = parent.global_position.direction_to(starting_point).normalized()
	var distance_to_target = parent.global_position.distance_to(starting_point)	
	var distace_based_strength = remap(clamp(distance_to_target, 0, max_range), 0, max_range, 0, 1)
	
	for i in range(normalized_directions.size()):
		var direction = normalized_directions[i]
		var interest = max(0, direction.dot(direction_to_target)) * distace_based_strength * strenght
		interest_map[i] = max(interest_map[i], interest)


