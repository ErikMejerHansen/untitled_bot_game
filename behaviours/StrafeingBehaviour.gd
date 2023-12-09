class_name StrafingBehaviour
extends Behaviour

var parent: Node2D
var optimal_strafe_distance = 600
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()


func _update_interest_map(interest_map: Array, strenght: float):
	# TODO: Move target selection to export in parent
	var target_position = get_tree().get_first_node_in_group("player").global_position
	var strafe_left = parent.global_position.direction_to(target_position).rotated(PI/2)
	var distance_to_target = parent.global_position.distance_to(target_position)
	
	if(distance_to_target > optimal_strafe_distance):
		strafe_left = strafe_left.rotated(-PI/6)
	elif (distance_to_target < optimal_strafe_distance):
		strafe_left = strafe_left.rotated(PI/6)

	
	for i in range(normalized_directions.size()):
		var direction = normalized_directions[i]
		var interest = max(0, direction.dot(strafe_left)) * strenght
		interest_map[i] = max(interest_map[i], interest)
