class_name Gatlin
extends Armament

@export var max_heat:float = 1000.0
@export var heat_increment = 5
@export var heat_decrement = 100
@export var color_change: GradientTexture1D

@export var spin_needed: float = 200
@export var spin_increase: float = 5
@export var spin_decrease: float = 1
@export var max_spin: float = 400

var current_heat:float = 0.0
var current_spin_speed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_heat -= heat_decrement * delta
	current_heat = max(0, current_heat)
	
	var color_overlay = color_change.gradient.sample(current_heat/max_heat)
	modulate = color_overlay
	
	current_spin_speed -= spin_decrease
	current_spin_speed = max(0, current_spin_speed)


func shoot():
	current_spin_speed += spin_increase
	current_spin_speed = min(current_spin_speed, max_spin)
	
	if current_spin_speed < spin_needed:
		return
	
	if current_heat < max_heat:	
		current_heat += heat_increment
		super.shoot()
	
	if current_heat > heat_increment:
		# Overheat! 
		current_heat * 2
