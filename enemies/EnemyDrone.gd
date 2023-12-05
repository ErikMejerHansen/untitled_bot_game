class_name EnemyDrone
extends CharacterBody2D



const DROP_SHADOW_OFFSET = Vector2(-100, -275)

@onready var area_2d = $Area2D
@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_idle_state = $FiniteStateMachine/EnemyIdleState as EnemyIdleState
@onready var enemy_alert_state = $FiniteStateMachine/EnemyAlertState as EnemyAlertState

var guns_deployed = false

func _ready():
	$AnimationPlayer.play("idle")
	
	enemy_idle_state.player_detected.connect(fsm.change_state.bind(enemy_alert_state))
	enemy_alert_state.player_lost.connect(fsm.change_state.bind(enemy_idle_state))
	


func _physics_process(delta):
	$DroneShadow.global_rotation = 0
	$DroneShadow.global_position = global_position - DROP_SHADOW_OFFSET
	
func _on_die(_damage_source: Node2D):
	queue_free()

func _deploy_guns():
	if guns_deployed:
		return
	
	guns_deployed = true
	$AnimationPlayer.play("deploy_guns")
	
	$Node2D/MainBodyAlert.visible = true
	$PointLight2D.color = Color("ff4d00")
	$PointLight2D.energy = 0.5
	
	
func _stow_guns():
	if not guns_deployed:
		return
		
	guns_deployed = false
	$AnimationPlayer.play_backwards("deploy_guns")
	
	$Node2D/MainBodyAlert.visible = false
	$PointLight2D.energy = 0.1
	$PointLight2D.color = Color.WHITE
	


#func _on_area_2d_body_entered(body):
	#if(body.is_in_group("player")):
		#_deploy_guns()
#
#func _on_area_2d_body_exited(body):
	#var bodies: Array[Node2D] = area_2d.get_overlapping_bodies()
	#var players_in_area = bodies.filter(func(it): it.is_in_group("player"))
	#
	#if players_in_area.size() == 0:
		#_stow_guns()

func _on_enemy_idle_state_player_detected():
	_deploy_guns()


func _on_player_lost():
	_stow_guns()
