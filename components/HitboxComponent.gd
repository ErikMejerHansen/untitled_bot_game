class_name HitboxComponent
extends Area2D

@export var health_component: HealthComponent
@export var hit_effect: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func damage(amount, hit_location):
	if health_component:
		health_component.damage(amount)
	
	if hit_effect:
		var effect = hit_effect.instantiate()
		add_child(effect)
		effect.global_position = hit_location
		effect.restart()
		
#		if not area.is_in_group("player"):
#		$BulletSprite.hide()
#		$Fragments.restart()
#		await get_tree().create_timer($Fragments.lifetime).timeout
