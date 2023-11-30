extends RigidBody2D

@export var on_destruction_effect: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_die():
	var effect = on_destruction_effect.instantiate()
	effect.global_position = global_position
	# TODO This should be from away from the hit location
	# the angle of a vector pointing from hit_location to origin of the crate
	effect.rotate(linear_velocity.angle())
	
	get_parent().add_child(effect)
	effect.restart()
	queue_free()
