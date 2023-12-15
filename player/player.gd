extends CharacterBody2D

@onready var weapon_1 = $right_arm/Weapon1
@onready var weapon_2 = $right_arm/Weapon2
@onready var weapon_3 = $left_arm/Weapon3
@onready var weapon_4 = $left_arm/Weapon4

@export var SPEED = 100.0
@export var ROTATE_SPEED = 0.7

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
		
	var input_direction = Input.get_vector("backward", "forward", "left", "right")
	var movement_direction = input_direction.rotated(rotation)
	
	velocity = movement_direction * SPEED
	
	if(input_direction.x > 0):
		$AnimationPlayer.play("forward")
	if(input_direction.x < 0):
		$AnimationPlayer.play_backwards("forward")
	
	move_and_slide()

func _shoot():
	weapon_1.shoot()
	weapon_2.shoot()
	weapon_3.shoot()
	weapon_4.shoot()

func _on_arm_rotation_clamp(clockwise):
	if(clockwise):
		rotate_clockwise = true
	else:
		rotate_counter_clockwise = true


func _on_health_component_die(bullet):
	get_tree().reload_current_scene()
