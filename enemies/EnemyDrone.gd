class_name EnemyDrone
extends CharacterBody2D



const DROP_SHADOW_OFFSET = Vector2(-100, -275)

@onready var area_2d = $Area2D

@export var max_speed = 50
@export var collision_detection_range = 1000

@export_category("Behaviours")
@export_range(0, 1, 0.1) var obstacle_avoidance = 0.5
@export_range(0, 1, 0.1) var wander = 0.5



@export_category("Debug")
@export var draw_context_maps: bool = false

@export var debug_circle_radius = 200
@export var interest_map_scale = 100

var guns_deployed = false

# Right, down, left, up
var interest_map = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var danger_map = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

var normalized_directions = [
		Vector2.RIGHT.normalized(), # East
		Vector2(1, 1).normalized(), # South East
		Vector2.DOWN.normalized(), # South
		Vector2(-1, 1).normalized(), # South West
		Vector2.LEFT.normalized(), # West
		Vector2(-1, -1).normalized(), # North West
		Vector2.UP.normalized(), # North
		Vector2(1, -1).normalized() # North East
	]

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
	
	var new_velocity = Vector2.ZERO
	
	for i in range(normalized_directions.size()):
		var direction = normalized_directions[i]
		var interest = interest_map[i]
		var danger = danger_map[i]
		new_velocity += direction * (interest * wander)
		new_velocity -= direction * (danger * obstacle_avoidance)

	velocity = velocity.move_toward(new_velocity * max_speed, delta * 100)
	rotation = velocity.angle()
		
	if draw_context_maps:
		queue_redraw()
	
	move_and_slide()

func _update_danger_map():
	var space_state = get_world_2d().direct_space_state
	for i in range(normalized_directions.size()):
		var foo = Vector2.ZERO
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + (normalized_directions[i] * collision_detection_range))
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result:
			var distance = result.position - global_position - normalized_directions[i] * 144
			var danger = remap(distance.length(), 0, collision_detection_range, 1, 0)
			danger_map[i] = danger
		else:
			danger_map[i] = 0

func _update_interest_map():
	var target = get_tree().get_first_node_in_group("player")
	var direction_to_target = global_position.direction_to(target.global_position).normalized()
	
	### Seek player
	#for i in range(normalized_directions.size()):
		#var direction = normalized_directions[i]
		#interest_map[i] = max(0, direction.dot(direction_to_target))

	### Noise based Random walk
	for i in range(normalized_directions.size()):
		var direction = normalized_directions[i]
		var direction_weight = noise.get_noise_2dv(direction * time)
		interest_map[i] = remap(direction_weight, -1, 1, 0, 1)


func _draw():
	if draw_context_maps:
		_debug_draw()

func _debug_draw():
	draw_arc(Vector2.ZERO, debug_circle_radius, 0, TAU, 64, Color.WHITE, 10.0)
	_debug_draw_eight_way_context_map(danger_map, Color.RED)
	_debug_draw_eight_way_context_map(interest_map, Color.GREEN)
	
	draw_line(Vector2.ZERO, velocity.rotated(-rotation) * 10, Color.AQUA, 10)

func _debug_draw_eight_way_context_map(context_map, color):	
	for i in range(normalized_directions.size()):
		var direction = normalized_directions[i].rotated(-rotation)
		var magnitude = direction * (debug_circle_radius + interest_map_scale * context_map[i])
		draw_line(direction * debug_circle_radius, magnitude, color, 10.0)

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
