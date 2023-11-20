class_name ClampedRotationNode
extends Node

signal rotation_clamped(is_cw:bool)

@export var min_angle: float = 0.0
@export var max_angle: float = 0.0
@export var sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	sprite.look_at(sprite.get_global_mouse_position())
	var clamped_rotation = clampf(sprite.rotation, deg_to_rad(min_angle), deg_to_rad(max_angle))
	
	if(clamped_rotation < sprite.rotation):
		rotation_clamped.emit(true)
	
	if (clamped_rotation > sprite.rotation):
		rotation_clamped.emit(false)
	
	sprite.rotation = clamped_rotation
