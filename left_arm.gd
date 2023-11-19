extends Sprite2D
signal arm_rotation_clamp(clockwise)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	var clamped_rotation = clampf(rotation, deg_to_rad(-45), deg_to_rad(35))
	
	if(clamped_rotation < rotation):
		arm_rotation_clamp.emit(true)
	
	if (clamped_rotation > rotation):
		arm_rotation_clamp.emit(false)
	
	rotation = clamped_rotation
