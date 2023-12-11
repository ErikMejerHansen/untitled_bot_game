class_name EnemyDrone
extends CharacterBody2D

const DROP_SHADOW_OFFSET = Vector2(-100, -275)

@onready var area_2d = $Area2D
@export var max_speed = 50

@onready var behaviours = $Behaviours as Behaviours
@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_idle_state = $FiniteStateMachine/EnemyIdleState as EnemyIdleState
@onready var enemy_alert_state = $FiniteStateMachine/EnemyAlertState as EnemyAlertState
@onready var enemy_attack_state = $FiniteStateMachine/EnemyAttackState

var guns_deployed = false


func _ready():
	$AnimationPlayer.play("idle")
	enemy_idle_state.player_detected.connect(fsm.change_state.bind(enemy_alert_state))
	enemy_alert_state.player_lost.connect(fsm.change_state.bind(enemy_idle_state))
	enemy_alert_state.alert_state_timer_fired.connect(fsm.change_state.bind(enemy_attack_state))


func _physics_process(delta):
	$DroneShadow.global_rotation = 0
	$DroneShadow.global_position = global_position - DROP_SHADOW_OFFSET
	
	var target_velocity = behaviours.get_target_velocity()

	velocity = velocity.move_toward(target_velocity * max_speed, delta * 100)
	rotation = velocity.angle()

	move_and_slide()

func _on_die(_damage_source: Node2D):
	queue_free()

func _deploy_guns():
	if guns_deployed:
		return
	
	guns_deployed = true
	$AnimationPlayer.play("deploy_guns")
	
	$Sprites/MainBodyAlert.visible = true
	$PointLight2D.color = Color("ff4d00")
	$PointLight2D.energy = 0.5
	
	
func _stow_guns():
	if not guns_deployed:
		return
		
	guns_deployed = false
	$AnimationPlayer.play_backwards("deploy_guns")
	
	$Sprites/MainBodyAlert.visible = false
	$Sprites/MainBodyAttack.visible = false
	
	$PointLight2D.energy = 0.1
	$PointLight2D.color = Color.WHITE
	
func attack(_target: Node2D):
	$Sprites/MainBodyAlert.visible = false
	$Sprites/MainBodyAttack.visible = true
	
	$PointLight2D.color = Color("red")
	$PointLight2D.energy = 0.6

func _on_enemy_idle_state_player_detected():
	_deploy_guns()


func _on_player_lost():
	_stow_guns()
