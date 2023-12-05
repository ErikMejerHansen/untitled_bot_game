class_name EnemyAlertState
extends State

signal player_lost

@export var actor: EnemyDrone

@export var search_area: Area2D

@export_category("Persuit Behaviour")
@export var persuit_distance = 1000.0
@export var acceleration = 450.0
@export var max_speed = 400.0



@onready var player = get_tree().get_first_node_in_group("player") as Node2D

func _ready():
	set_physics_process(false)

func _enter_state():
	super._enter_state()
	actor._deploy_guns()
	
	search_area.body_exited.connect(_body_exited)
	

func _exit_state():
	super._exit_state()
	
	search_area.body_exited.disconnect(_body_exited)

func _physics_process(delta):
	var player_position: Vector2 = player.global_position
	var target_rotation = actor.global_position.direction_to(player_position).angle()
	
	var look_direction = lerp_angle(actor.rotation, target_rotation, delta * 5)
	actor.rotation = look_direction
	var distance_to_player = actor.global_position.distance_to(player_position)
	
	if distance_to_player > persuit_distance:
		actor.velocity = actor.velocity.move_toward(actor.global_position.direction_to(player_position) * max_speed, acceleration * delta)
		actor.rotation = actor.velocity.angle()
		
		
	else:
		actor.velocity = Vector2.ZERO
	
	actor.move_and_slide()
	

func _body_exited(_body):
	var bodies: Array[Node2D] = search_area.get_overlapping_bodies()
	var players_in_area = bodies.filter(func(it): return it.is_in_group("player"))
	
	if players_in_area.size() == 0:
		print("Lost player:", bodies)
		player_lost.emit()
