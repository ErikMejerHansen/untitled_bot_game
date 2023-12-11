class_name EnemyIdleState
extends State

signal player_detected(body: Node2D)

@export var actor: EnemyDrone
@export var detection_area: Area2D
@export var behaviours: Behaviours

var anchor_point: Vector2
var next_waypoint =  Vector2.ZERO

func _ready():
	anchor_point = actor.global_position
	set_physics_process(false)

func _enter_state():
	super._enter_state()
	detection_area.body_entered.connect(_body_entered)
	
	behaviours.seek_player_strength = 0.0
	behaviours.guard_starting_point_strength = 0.6
	behaviours.random_walk_strength = 0.8
	behaviours.obstacle_avoidance_strength = 1.0
	actor._stow_guns()

func _exit_state():
	super._exit_state()
	detection_area.body_entered.disconnect(_body_entered)

func _body_entered(body):
	if body.is_in_group("player"):
		player_detected.emit()
