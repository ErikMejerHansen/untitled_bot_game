class_name ChainSword
extends Armament

@export var animated_sprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	match side:
		ArmSide.Left:
			scale = Vector2(1, -1)
			if muzzle_flash: muzzle_flash.scale = Vector2(1, -1)
			rotation_clamp.max_angle = 25
			rotation_clamp.min_angle = -85
		ArmSide.Right:
			rotation_clamp.max_angle = 85
			rotation_clamp.min_angle = -25


func _process(delta):
	if animated_sprite.is_playing():
		animated_sprite.pause()
	pass

func shoot():
	animated_sprite.play()
	pass


