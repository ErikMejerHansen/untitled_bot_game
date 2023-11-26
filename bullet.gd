class_name Bullet
extends Area2D

@export var damage:int = 10
@export var SPEED:int = 1300

var sparks = preload("res://effects/hard_surface_sparks.tscn")
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


func _on_body_entered(body):
	if _hit_hard_surface(body):
		show_sparks()
		
		
	if not body.is_in_group("player"):
		queue_free()
	
func _hit_hard_surface(body):
	return body is TileMap

func show_sparks():
	var s = sparks.instantiate()
	s.global_position = global_position
	s.rotation_degrees = rotation_degrees - 180
	get_tree().root.add_child(s)
	s.restart()
