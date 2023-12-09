class_name ObstacleAvoidanceBehaviour
extends Behaviour

var parent: Node2D
var collision_detection_range: float

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	collision_detection_range = parent.collision_detection_range

func _update_danger_map(danger_map: Array, strenght: float):
	
	var space_state = parent.get_world_2d().direct_space_state
	for i in range(normalized_directions.size()):
		var query = PhysicsRayQueryParameters2D.create(parent.global_position, parent.global_position + (normalized_directions[i] * collision_detection_range))
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result:
			var distance = result.position - parent.global_position - normalized_directions[i] * 144
			var danger = remap(distance.length(), 0, collision_detection_range, 1, 0) * strenght
			danger_map[i] = max(danger_map[i], danger)
