class_name EnemyDrone
extends CharacterBody2D



const DROP_SHADOW_OFFSET = Vector2(-100, -275)

@onready var area_2d = $Area2D
@onready var ray_cast_2d_down = $RayCast2DDown
@onready var ray_cast_2d_up = $RayCast2DUp
@onready var ray_cast_2d_left = $RayCast2DLeft
@onready var ray_cast_2d_right = $RayCast2DRight

@export var max_speed = 50
@export var collision_detection_range = 1000
@export_range(0, 1, 0.1) var obstacle_avoidance = 0.5

@export_category("Debug")
@export var debug_draw = false
@export var debug_circle_radius = 200
@export var interest_map_scale = 100

var guns_deployed = false

# Right, down, left, up
var interest_map = [0.0, 0.0, 0.0, 0.0]
var danger_map = [0.0, 0.0, 0.0, 0.0]

var noise = FastNoiseLite.new()
var time = 0

func _ready():
	noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX
	noise.seed = randi()
	noise.fractal_octaves = 4
	noise.frequency = 1.0 / 20.0
	
	$AnimationPlayer.play("idle")	


func _physics_process(delta):
	time += delta
	$DroneShadow.global_rotation = 0
	$DroneShadow.global_position = global_position - DROP_SHADOW_OFFSET
	
	_update_interest_map()
	_update_danger_map()
	
	#velocity = (Vector2.LEFT * interest_map[0] + Vector2.LEFT * -danger_map[0] \
		#+ Vector2.DOWN * interest_map[1] + Vector2.LEFT * -danger_map[1]  \
		#+ Vector2.RIGHT * interest_map[2] + Vector2.LEFT * -danger_map[2]  \
		#+ Vector2.UP * interest_map[3] + Vector2.LEFT * -danger_map[3] 
		#) * max_speed
	
	
	#
	#print("interest:", interest_map)
	#print("danger:", danger_map)
	#print("velocity:", velocity)
	#
	#var candidate_list = []
	#candidate_list.push_back( interest_map[0] if danger_map[0] < 0.2 else 0)
	#candidate_list.push_back( interest_map[1] if danger_map[1] < 0.2 else 0)
	#candidate_list.push_back( interest_map[2] if danger_map[2] < 0.2 else 0)
	#candidate_list.push_back( interest_map[3] if danger_map[3] < 0.2 else 0)
	#
	#var direction = candidate_list.find(candidate_list.max())
	#
	#print("Direction:", direction)
	#match direction:
		#0: velocity = candidate_list[0] * Vector2.RIGHT * max_speed
		#1: velocity = candidate_list[1] * Vector2.DOWN * max_speed
		#2: velocity = candidate_list[2] * Vector2.LEFT * max_speed
		#3: velocity = candidate_list[3] * Vector2.RIGHT * max_speed
		#
	##
	#velocity = (\
		#Vector2.RIGHT * right_impulse \
		#+ Vector2.DOWN * down_impulse \
		#+ Vector2.LEFT * left_impulse \
		#+ Vector2.UP * up_impulse \
	#) * max_speed
	
	#var velocity_danger_component = (Vector2.RIGHT * -danger_map[0] \
	#+ Vector2.DOWN * -danger_map[1] \
	#+ Vector2.LEFT * -danger_map[2] \
	#+ Vector2.UP * -danger_map[3])
	#print(danger_map)
	#
	#var velocity_wander_component = Vector2.RIGHT * interest_map[0] \
	#+ Vector2.DOWN * interest_map[1] \
	#+ Vector2.LEFT * interest_map[2] \
	#+ Vector2.UP * interest_map[3]
	#
	#velocity = (velocity_danger_component + (velocity_wander_component * 0.01)) * max_speed
	
	#print("wander:", velocity_wander_component)
	#print("danger:", velocity_danger_component)
	#
	rotation = velocity.angle()
	
	if debug_draw:
		queue_redraw()
	
	move_and_slide()

func _update_danger_map():
	var collision_distance_right = ray_cast_2d_right.global_position.distance_to(ray_cast_2d_right.get_collision_point())
	var collision_distance_down = ray_cast_2d_down.global_position.distance_to(ray_cast_2d_down.get_collision_point())
	var collision_distance_left = ray_cast_2d_left.global_position.distance_to(ray_cast_2d_left.get_collision_point())
	var collision_distance_up = ray_cast_2d_up.global_position.distance_to(ray_cast_2d_up.get_collision_point())
	
	
	var collision_distance_right_clamped = clamp(collision_distance_right, 0, collision_detection_range)
	var collision_distance_down_clamped = clamp(collision_distance_down, 0, collision_detection_range)
	var collision_distance_left_clamped = clamp(collision_distance_left, 0, collision_detection_range)
	var collision_distance_up_clamped = clamp(collision_distance_up, 0, collision_detection_range)

	var danger_right = remap(collision_distance_right_clamped, 0, collision_detection_range, 1, 0)
	var danger_down = remap(collision_distance_down_clamped, 0, collision_detection_range, 1, 0)
	var danger_left = remap(collision_distance_left_clamped, 0, collision_detection_range, 1, 0)
	var danger_up = remap(collision_distance_up_clamped, 0, collision_detection_range, 1, 0)
	
	danger_map[0] = danger_right if ray_cast_2d_right.is_colliding() else 0
	danger_map[1] = danger_down if ray_cast_2d_down.is_colliding() else 0
	danger_map[2] = danger_left if ray_cast_2d_left.is_colliding() else 0
	danger_map[3] = danger_up if ray_cast_2d_up.is_colliding() else 0
	
func _update_interest_map():
	var target = get_tree().get_first_node_in_group("player")
	var direction_to_target = global_position.direction_to(target.global_position).normalized()
	
	# Weigh towards player
	interest_map[0] = max(0, Vector2.RIGHT.dot(direction_to_target))
	interest_map[1] = max(0, Vector2.DOWN.dot(direction_to_target))
	interest_map[2] = max(0, Vector2.LEFT.dot(direction_to_target))
	interest_map[3] = max(0, Vector2.UP.dot(direction_to_target))
	
	## Noise based Random walk
	#var right = noise.get_noise_2d(time, 0)
	#var down = noise.get_noise_2d(0, time)
	#
	#if right > 0:
		#interest_map[0] = right
	#else:
		#interest_map[2] = abs(right)
		#
	#if down > 0:
		#interest_map[1] = down
	#else:
		#interest_map[3] = abs(down)

	
func _draw():
	if debug_draw:
		_debug_draw()



func _debug_draw():
	draw_arc(Vector2.ZERO, debug_circle_radius, 0, TAU, 64, Color.WHITE, 10.0)
	#_debug_draw_interest_map()
	_debug_draw_four_way_context_map(danger_map, Color.RED)
	

func _debug_draw_interest_map():
	var left = Vector2.LEFT * (debug_circle_radius + interest_map_scale * interest_map[0])
	var down = Vector2.DOWN * (debug_circle_radius  + interest_map_scale * interest_map[1])
	var right = Vector2.RIGHT * (debug_circle_radius  + interest_map_scale * interest_map[2])
	var up = Vector2.UP * (debug_circle_radius  + interest_map_scale * interest_map[3])
	
	
	
	draw_line(Vector2.LEFT * debug_circle_radius, left, Color.BLUE, 10.0)
	draw_line(Vector2.DOWN * debug_circle_radius, down, Color.BLUE, 10.0)
	draw_line(Vector2.RIGHT * debug_circle_radius, right, Color.BLUE, 10.0)
	draw_line(Vector2.UP * debug_circle_radius, up, Color.BLUE, 10.0)
	

func _debug_draw_four_way_context_map(context_map, color):
	print(danger_map)
	var right = Vector2.RIGHT * (debug_circle_radius  + interest_map_scale * context_map[0])
	var down = Vector2.DOWN * (debug_circle_radius  + interest_map_scale * context_map[1])
	var left = Vector2.LEFT * (debug_circle_radius + interest_map_scale * context_map[2])
	var up = Vector2.UP * (debug_circle_radius  + interest_map_scale * context_map[3])
	
	
	
	draw_line(ray_cast_2d_right.position.normalized() * debug_circle_radius, right, color, 10.0)
	draw_line(ray_cast_2d_down.position.normalized() * debug_circle_radius, down, color, 10.0)
	draw_line(ray_cast_2d_left.position.normalized() * debug_circle_radius, left, color, 10.0)
	draw_line(ray_cast_2d_up.position.normalized() * debug_circle_radius, up, color, 10.0)

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
	

func _on_enemy_idle_state_player_detected():
	_deploy_guns()


func _on_player_lost():
	_stow_guns()
