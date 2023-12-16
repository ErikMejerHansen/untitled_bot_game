class_name Armament
extends Sprite2D

signal rotation_clamped(is_cw:bool)

enum ArmSide {Left, Right}

@export var side: ArmSide
@export var weapon_1 : Weapon
@export var weapon_2 : Weapon

@onready var muzzle_flash = $MuzzleFlash
@onready var rotation_clamp = $RotationClamp as ClampedRotationNode


# Called when the node enters the scene tree for the first time.
func _ready():
	match side:
		ArmSide.Left:
			scale = Vector2(1, -1)
			muzzle_flash.scale = Vector2(1, -1)
			rotation_clamp.max_angle = 15
			rotation_clamp.min_angle = -25
		ArmSide.Right:
			rotation_clamp.max_angle = 15
			rotation_clamp.min_angle = -15
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func shoot():
	if weapon_1:
		weapon_1.shoot()
	if weapon_2:
		weapon_2.shoot()
	


func _on_rotation_clamp_rotation_clamped(is_cw):
	rotation_clamped.emit(is_cw)
