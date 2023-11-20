class_name Bullet
extends Area2D

@export var SPEED:int = 750
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	position += transform.x * SPEED * delta

func _on_body_entered(body):
	if not body.is_in_group("player"):
		$BulletSprite.hide()
		$Fragments.restart()
		await get_tree().create_timer($Fragments.lifetime).timeout
		queue_free()
