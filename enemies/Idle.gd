class_name EnemyIdleState
extends State

@export var actor: EnemyDrone

@export_category("Search Behaviour")
@export var idle_search_radius = 50.0
@export var acceleration = 50.0 # Should live on Drone
@export var max_speed = 500.0

var anchor_point: Vector2
var next_waypoint =  Vector2.ZERO

func _ready():
	anchor_point = actor.global_position
	set_physics_process(false)

func _enter_state():
	super._enter_state()
	_select_next_waypoint()

func _exit_state():
	super._exit_state()

func _physics_process(delta):
	if _is_at_max_search_distance():
		_select_next_waypoint()
	
	actor.velocity = actor.velocity.move_toward(next_waypoint * max_speed, acceleration * delta)
	actor.rotation = actor.velocity.angle()
	
	actor.move_and_slide()

func _select_next_waypoint():
	var random_direction = randf_range(0, TAU)
	var random_destination = Vector2.from_angle(random_direction) * idle_search_radius
	var offset_direction = random_destination + anchor_point
	
	var direction = actor.global_position.direction_to(offset_direction)
	
	next_waypoint = direction

func _is_at_max_search_distance():
	var distance_from_anchor = anchor_point - actor.global_position
	
	return distance_from_anchor.length() >= idle_search_radius
