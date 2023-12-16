extends CharacterBody2D


@export var SPEED = 100.0
@export var ROTATE_SPEED = 0.7

@export_category("Armaments")
@export var left_armament: Armament
@export var right_armament: Armament


var rotate_clockwise = false
var rotate_counter_clockwise = false

func _physics_process(delta):
	
	if Input.is_action_pressed("shoot"):
		_shoot()
	
	if(rotate_clockwise):
		rotation += ROTATE_SPEED * delta
		rotate_clockwise = false
	
	if(rotate_counter_clockwise):
		rotation -= ROTATE_SPEED * delta
		rotate_counter_clockwise = false
		
	#var input_direction = Input.get_vector("backward", "forward", "left", "right")
	var input_direction = Input.get_vector("backward", "forward", "left", "right")
	var movement_direction = input_direction.rotated(rotation)
	
	velocity = movement_direction * SPEED
	
	if(input_direction.x > 0):
		$AnimationPlayer.play("forward")
	if(input_direction.x < 0):
		$AnimationPlayer.play_backwards("forward")
	
	move_and_slide()

func _shoot():
	if left_armament:
		left_armament.shoot()
	if right_armament:
		right_armament.shoot()

func _on_arm_rotation_clamp(clockwise):
	if(clockwise):
		rotate_clockwise = true
	else:
		rotate_counter_clockwise = true


func _on_health_component_die(_bullet):
	get_tree().reload_current_scene()
