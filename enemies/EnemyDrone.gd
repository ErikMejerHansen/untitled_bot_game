class_name EnemyDrone
extends CharacterBody2D



const DROP_SHADOW_OFFSET = Vector2(-100, -275)

@onready var area_2d = $Area2D

@onready var rays = $Rays as Node2D
@onready var ray_cast_2d_east = $Rays/RayCast2DEast
@onready var ray_cast_2d_south_east = $Rays/RayCast2DSouthEast
@onready var ray_cast_2d_south = $Rays/RayCast2DSouth
@onready var ray_cast_2d_south_west = $Rays/RayCast2DSouthWest
@onready var ray_cast_2d_west = $Rays/RayCast2DWest
@onready var ray_cast_2d_north_west = $Rays/RayCast2DNorthWest
@onready var ray_cast_2d_north = $Rays/RayCast2DNorth
@onready var ray_cast_2d_north_east = $Rays/RayCast2DNorthEast

@export var max_speed = 50
@export var collision_detection_range = 1000
@export_range(0, 1, 0.1) var obstacle_avoidance = 0.5

@export_category("Debug")
@export var debug_draw = false
@export var debug_circle_radius = 200
@export var interest_map_scale = 100

var guns_deployed = false

# Right, down, left, up
var interest_map = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var danger_casts = []
var danger_map = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

var noise = FastNoiseLite.new()
var time = 0

func _ready():
	noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX
	noise.seed = randi()
	noise.fractal_octaves = 4
	noise.frequency = 1.0 / 20.0
	danger_casts = [ray_cast_2d_east, ray_cast_2d_south_east, ray_cast_2d_south, ray_cast_2d_south_west, ray_cast_2d_west, ray_cast_2d_north_west, ray_cast_2d_north, ray_cast_2d_north_east]
	
	$AnimationPlayer.play("deploy_guns")	


func _physics_process(delta):
	time += delta
	$DroneShadow.global_rotation = 0
	$DroneShadow.global_position = global_position - DROP_SHADOW_OFFSET
	
	rays.rotation = -rotation
	
	_update_interest_map()
	_update_danger_map()
	
	var directions = [
		Vector2.RIGHT, # East
		Vector2(1, 1), # South East
		Vector2.DOWN, # South
		Vector2(-1, 1), # South West
		Vector2.LEFT, # West
		Vector2(-1, -1), # North West
		Vector2.UP, # North
		Vector2(1, -1) # North East
	]
	
	#var rotated_direction = directions.map(func d: return d.rotated(rotation))
	# There is a bug when we're rotated
	#var rotated_directions = directions.map(func(direction): return direction.rotated(rotation).normalized())
	var new_velocity = Vector2.ZERO
	
	for i in range(directions.size()):
		var direction = directions[i]
		var interest = interest_map[i]
		var danger = danger_map[i]
		#new_velocity += direction.normalized() * interest
		new_velocity -= direction.normalized() * danger

	velocity = new_velocity * max_speed
	#rotation = velocity.angle()
		
	if debug_draw:
		queue_redraw()
	
	move_and_slide()

func _update_danger_map():
	for i in range(danger_casts.size()):
		var ray = danger_casts[i]
		var collision_distance = ray.global_position.distance_to(ray.get_collision_point())
		var collision_distance_clamped = clamp(collision_distance, 0, collision_detection_range)
		var danger = remap(collision_distance_clamped, 0, collision_detection_range, 1, 0)
		
		danger_map[i] = danger if ray.is_colliding() else 0
		
func _update_interest_map():
	var target = get_tree().get_first_node_in_group("player")
	var direction_to_target = global_position.direction_to(target.global_position).normalized()
	
	var directions = [
		Vector2.RIGHT, # East
		Vector2(1, 1), # South East
		Vector2.DOWN, # South
		Vector2(-1, 1), # South West
		Vector2.LEFT, # West
		Vector2(-1, -1), # North West
		Vector2.UP, # North
		Vector2(1, -1) # North East
	]
	
	### Seek player
	#for i in range(directions.size()):
		#var direction = directions[i].normalized()
		#interest_map[i] = max(0, direction.dot(direction_to_target))

	### Noise based Random walk
	for i in range(directions.size()):
		var direction = directions[i].normalized()
		var direction_weight = noise.get_noise_2dv(direction * time)
		interest_map[i] = remap(direction_weight, -1, 1, 0, 1)

	
func _draw():
	if debug_draw:
		_debug_draw()



func _debug_draw():
	draw_arc(Vector2.ZERO, debug_circle_radius, 0, TAU, 64, Color.WHITE, 10.0)
	_debug_draw_eight_way_context_map(danger_map, Color.RED)
	#_debug_draw_eight_way_context_map(interest_map, Color.GREEN)
	
	draw_line(Vector2.ZERO, velocity.rotated(-rotation) * 10, Color.AQUA, 10)

func _debug_draw_eight_way_context_map(context_map, color):
	var directions = [
		Vector2.RIGHT, # East
		Vector2(1, 1), # South East
		Vector2.DOWN, # South
		Vector2(-1, 1), # South West
		Vector2.LEFT, # West
		Vector2(-1, -1), # North West
		Vector2.UP, # North
		Vector2(1, -1) # North East
	]
	
	for i in range(directions.size()):
		var direction = directions[i].rotated(-rotation).normalized()
		var magnitude = direction * (debug_circle_radius + interest_map_scale * context_map[i])
		draw_line(direction * debug_circle_radius, magnitude, color, 10.0)
		
	#
	#var east = Vector2.RIGHT * (debug_circle_radius  + interest_map_scale * context_map[0])
	#var south_east = Vector2(1, 1).normalized() * (debug_circle_radius  + interest_map_scale * context_map[1])
	#var south = Vector2.DOWN * (debug_circle_radius  + interest_map_scale * context_map[2])
	#var south_west = Vector2(-1, -1).normalized() * (debug_circle_radius  + interest_map_scale * context_map[3])
	#var west = Vector2.LEFT * (debug_circle_radius + interest_map_scale * context_map[4])
	#var north_west = Vector2(-1, -1).normalized() * (debug_circle_radius  + interest_map_scale * context_map[5])
	#var north = Vector2.UP * (debug_circle_radius  + interest_map_scale * context_map[6])
	#var north_east = Vector2(-1, 1).normalized() * (debug_circle_radius  + interest_map_scale * context_map[7])
	#
	#draw_line(Vector2.RIGHT * debug_circle_radius, east, color, 10.0)
	#draw_line(Vector2.DOWN * debug_circle_radius, south, color, 10.0)
	#draw_line(Vector2.LEFT * debug_circle_radius, west, color, 10.0)
	#draw_line(Vector2.UP * debug_circle_radius, north, color, 10.0)

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
