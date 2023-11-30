class_name HealthComponent
extends Node2D

signal die(bullet: Bullet)


@export var MAX_HEALTH := 100
var health : int
# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH


func damage(attack: int, bullet: Bullet):
	health -= attack
	if health <= 0:
		die.emit(bullet)
