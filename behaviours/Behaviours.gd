class_name Behaviours
extends Node2D


@export_category("Behaviour Mix")
@export_range(0, 1, 0.1) var seek_player_strength = 0.0
@export_range(0, 1, 0.1) var random_walk_strength = 0.0
@export_range(0, 1, 0.1) var obstacle_avoidance_strength = 0.0
@export_range(0, 1, 0.1) var guard_starting_point_strength = 0.0
@export_range(0, 1, 0.1) var strafing_strength = 0.0

@export_category("Obstacle Avoidance")
@export var collision_detection_range = 800

@export_category("Guard Startig Point")
@export var max_range = 200.0

@export_category("Debug")
@export var draw_context_maps: bool = false
@export var debug_circle_radius = 200
@export var interest_map_scale = 100

@onready var seek_player_behaviour = $SeekPlayerBehaviour
@onready var random_walk_behaviour = $RandomWalkBehaviour
@onready var obstacle_avoidance_behaviour = $ObstacleAvoidanceBehaviour
@onready var guard_starting_point_behaviour = $GuardStartingPointBehaviour
@onready var strafeing_behaviour = $StrafeingBehaviour


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

var parent: Node2D
var interest_map: Array = []
var danger_map: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent() as Node2D

func get_target_velocity():
	
	interest_map = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	danger_map = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

	seek_player_behaviour.update_context_maps(interest_map, danger_map, seek_player_strength)
	random_walk_behaviour.update_context_maps(interest_map, danger_map, random_walk_strength)
	obstacle_avoidance_behaviour.update_context_maps(interest_map, danger_map, obstacle_avoidance_strength)
	guard_starting_point_behaviour.update_context_maps(interest_map, danger_map, guard_starting_point_strength)
	strafeing_behaviour.update_context_maps(interest_map, danger_map, strafing_strength)
	
	var target_velocity = Vector2.ZERO
	for i in range(normalized_directions.size()):
		var direction = normalized_directions[i]
		var interest = interest_map[i]
		var danger = danger_map[i]
		target_velocity += direction * interest
		target_velocity -= direction * danger

	
		
	return target_velocity	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if draw_context_maps:
		queue_redraw()

func _draw():
	if draw_context_maps:
		_debug_draw()

func _debug_draw():
	draw_arc(Vector2.ZERO, debug_circle_radius, 0, TAU, 64, Color.WHITE, 10.0)
	_debug_draw_eight_way_context_map(interest_map, Color.GREEN)
	_debug_draw_eight_way_context_map(danger_map, Color.RED)
	
	draw_line(Vector2.ZERO, parent.velocity.rotated(-parent.rotation) * 10, Color.AQUA, 10)

func _debug_draw_eight_way_context_map(context_map, color):	
	for i in range(normalized_directions.size()):
		var direction = normalized_directions[i].rotated(-parent.rotation)
		var magnitude = direction * (debug_circle_radius + interest_map_scale * context_map[i])
		draw_line(direction * debug_circle_radius, magnitude, color, 10.0)
