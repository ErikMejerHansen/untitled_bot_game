extends CharacterBody2D


const SPEED = 100.0
const ROTATE_SPEED = 0.7

var rotate_clockwise = false
var rotate_counter_clockwise = false

@export var Bullet: PackedScene

func _physics_process(delta):
	
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


func _on_arm_rotation_clamp(clockwise):
	if(clockwise):
		rotate_clockwise = true
	else:
		rotate_counter_clockwise = true
