class_name Weapon

extends Node

@export var muzzle: Marker2D
@export var rate_of_fire: float
@export var Bullet: PackedScene
@export var muzzle_flash: Sprite2D

var can_fire = true


# Called when the node enters the scene tree for the first time.
func _ready():
	muzzle_flash.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot():
	if can_fire:
		muzzle_flash.show()
		can_fire = false
		var b = Bullet.instantiate()
		get_tree().get_root().add_child(b)
		b.transform = muzzle.global_transform
		await get_tree().create_timer(rate_of_fire).timeout
		can_fire = true
		muzzle_flash.hide()
