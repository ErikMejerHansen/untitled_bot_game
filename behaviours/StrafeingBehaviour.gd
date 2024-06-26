class_name StrafingBehaviour
extends Behaviour

var parent: Node2D
@export var optimal_strafe_distance = 300
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()


func _update_interest_map(interest_map: Array, strenght: float):
	
	var target = parent.strafing_target as Node2D
	if not target:
		return
		
	var target_position = target.global_position
	var strafe_left = parent.global_position.direction_to(target_position).rotated(PI/2)
	var distance_to_target = parent.global_position.distance_to(target_position)
	
	if(distance_to_target > optimal_strafe_distance):
		strafe_left = strafe_left.rotated(-PI/4)
	elif (distance_to_target < optimal_strafe_distance):
		strafe_left = strafe_left.rotated(PI/4)

	
	for i in range(normalized_directions.size()):
		var direction = normalized_directions[i]
		var interest = max(0, direction.dot(strafe_left)) * strenght
		interest_map[i] = max(interest_map[i], interest)
