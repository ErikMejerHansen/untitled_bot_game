class_name EnemyAlertState
extends State

signal player_lost

@export var actor: EnemyDrone

@export var search_area: Area2D
@export var behaviours: Behaviours


@onready var player = get_tree().get_first_node_in_group("player") as Node2D

func _ready():
	set_physics_process(false)

func _enter_state():
	super._enter_state()
	actor._deploy_guns()
	
	search_area.body_exited.connect(_body_exited)
	
	behaviours.seek_player_strength = 0.6
	behaviours.guard_starting_point_strength = 0.0
	behaviours.random_walk_strength = 0.3
	behaviours.strafing_strength = 1.0
	behaviours.strafing_target = player
	

func _exit_state():
	super._exit_state()
	
	search_area.body_exited.disconnect(_body_exited)

func _physics_process(delta):
	actor.rotation = actor.global_position.direction_to(player.global_position).angle()

	

func _body_exited(_body):
	var bodies: Array[Node2D] = search_area.get_overlapping_bodies()
	var players_in_area = bodies.filter(func(it): return it.is_in_group("player"))
	
	if players_in_area.size() == 0:
		player_lost.emit()
