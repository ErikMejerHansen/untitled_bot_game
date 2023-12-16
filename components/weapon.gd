class_name Weapon

extends Node

@export var muzzle: Marker2D
@export var rate_of_fire: float
@export var bullet: PackedScene
@export var muzzle_flash: Sprite2D

var can_fire = true


# Called when the node enters the scene tree for the first time.
func _ready():
	muzzle_flash.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func shoot():
	if can_fire:
		muzzle_flash.show()
		can_fire = false
		var b = bullet.instantiate()
		get_tree().get_root().add_child(b)
		b.transform = muzzle.global_transform
		await get_tree().create_timer(rate_of_fire/2).timeout
		muzzle_flash.hide()
		await get_tree().create_timer(rate_of_fire/2).timeout
		can_fire = true
	
	
