class_name SeekPlayerBehaviour
extends Behaviour


var parent: Node2D
func _ready():
	parent = get_parent()

func _update_interest_map(interest_map:Array, strenght: float):
	var target = get_tree().get_first_node_in_group("player")
	var direction_to_target = parent.global_position.direction_to(target.global_position).normalized()
	
	for i in range(normalized_directions.size()):
		var direction = normalized_directions[i]
		var interest = max(0, direction.dot(direction_to_target)) * strenght
		interest_map[i] = max(interest_map[i], interest)
