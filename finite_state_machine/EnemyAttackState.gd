class_name EnemyAttackState
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
	
	actor.attack(player)
	
	actor.max_speed = 350.0
	behaviours.seek_player_strength = 0.0
	behaviours.guard_starting_point_strength = 0.0
	behaviours.random_walk_strength = 0.2
	behaviours.strafing_strength = 1.0
	behaviours.strafing_target = player
	

func _exit_state():
	super._exit_state()

func _physics_process(_delta):
	actor.rotation = actor.global_position.direction_to(player.global_position).angle()

