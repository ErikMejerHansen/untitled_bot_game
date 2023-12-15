extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var weapon_3 = $Weapon3 as Weapon
@onready var weapon_4 = $Weapon4 as Weapon

enum Side {LEFT, RIGHT}
var last_fired_side 

# Called when the node enters the scene tree for the first time.
func _ready():
	last_fired_side = Side.LEFT
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func shoot():
	match last_fired_side:
		Side.LEFT:
			last_fired_side = Side.RIGHT
			weapon_3.shoot()
			animation_player.play("shoot_left")
			
		Side.RIGHT:
			last_fired_side = Side.LEFT
			weapon_4.shoot()
			animation_player.play("shoot_right")
