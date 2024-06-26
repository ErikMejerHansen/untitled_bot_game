extends RigidBody2D

@export var on_destruction_effect: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_die(damage_source: Node2D):
	
	var effect = on_destruction_effect.instantiate()
	effect.global_position = global_position
	
	var x = global_position - damage_source.global_position		
	effect.rotate(x.angle())
	
	get_parent().add_child(effect)
	effect.restart()
	queue_free()
