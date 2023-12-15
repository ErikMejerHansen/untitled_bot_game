class_name HealthComponent
extends Node2D

signal die(bullet: Bullet)

@export var hurt_effect: PackedScene
@export var MAX_HEALTH := 100

var triggered_hurt_effect = false
var is_dead = false

var health : int
# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH


func damage(attack: int, bullet: Bullet):
	health -= attack
	
	if health < MAX_HEALTH / 2.0 and hurt_effect and not triggered_hurt_effect:
		triggered_hurt_effect = true
		var effect = hurt_effect.instantiate()
		add_child(effect)
		effect.restart()
	
	
	if health <= 0 and not is_dead:
		is_dead = true
		die.emit(bullet)
