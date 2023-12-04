class_name EnemyAlertState
extends State

signal player_lost

@export var actor: EnemyDrone

@export_category("Search Behaviour")
@export var search_area: Area2D

@onready var player = get_tree().get_first_node_in_group("player") as Node2D

func _ready():
	set_physics_process(false)
	search_area.body_exited.connect(_body_exited)

func _enter_state():
	super._enter_state()
	actor._deploy_guns()
	
	search_area.body_exited.connect(_body_exited)
	

func _exit_state():
	super._exit_state()
	
	search_area.body_exited.disconnect(_body_exited)

func _physics_process(delta):
	#actor.look_at(player.global_position)
	var target_rotation = actor.global_position.angle_to_point(player.global_position)
	
	
	var look_direction = move_toward(actor.rotation, target_rotation, delta * 10)
	actor.rotation = look_direction

func _body_exited(_body):
	var bodies: Array[Node2D] = search_area.get_overlapping_bodies()
	var players_in_area = bodies.filter(func(it): it.is_in_group("player"))
	
	if players_in_area.size() == 0:
		player_lost.emit()
