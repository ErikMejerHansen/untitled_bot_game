class_name Bullet
extends Area2D

@export var damage:int = 10
@export var SPEED:int = 1300
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(delta):
	position += transform.x * SPEED * delta

func _on_area_entered(area):
	if area is HitboxComponent:
		var hitbox: HitboxComponent = area
		hitbox.damage(damage, global_position)
		queue_free()
