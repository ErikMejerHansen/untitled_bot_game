class_name HitboxComponent
extends Area2D



@export var health_component: HealthComponent
@export var hit_effect: PackedScene
@export var impact_component: ImpactComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func damage(amount, bullet: Bullet):
	
	if health_component:
		health_component.damage(amount, bullet)
		
	if impact_component:
		impact_component.hit(bullet)
	
	if hit_effect:
		var effect = hit_effect.instantiate()
		add_child(effect)
		effect.global_position = bullet.global_position
		effect.restart()
