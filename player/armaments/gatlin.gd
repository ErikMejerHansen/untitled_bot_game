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

@onready var overheat_smoke: GPUParticles2D = $OverheatSmoke
const RIGHT_GATLIN_BLURRED = preload("res://sprites/sprites/bot/right_gatlin_blurred.png")
const RIGHT_GATLIN = preload("res://sprites/sprites/bot/right_gatlin.png")

var current_heat:float = 0.0
var current_spin_speed = 0.0
var showing_blurred = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	match side:
		ArmSide.Left:
			scale = Vector2(1, -1)
			muzzle_flash.scale = Vector2(1, -1)
			rotation_clamp.max_angle = 15
			rotation_clamp.min_angle = -25
		ArmSide.Right:
			rotation_clamp.max_angle = 15
			rotation_clamp.min_angle = -15


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not showing_blurred and current_spin_speed > 0:
		showing_blurred = true
		texture = RIGHT_GATLIN_BLURRED
	
	if showing_blurred and current_spin_speed == 0:
		showing_blurred = false
		texture = RIGHT_GATLIN
	
	current_heat -= heat_decrement * delta
	current_heat = max(0, current_heat)
	
	var color_overlay = color_change.gradient.sample(current_heat/max_heat)
	self_modulate = color_overlay
	
	current_spin_speed -= spin_decrease
	current_spin_speed = max(0, current_spin_speed)

	if current_heat < max_heat and overheat_smoke.emitting:	
		overheat_smoke.emitting = false
		
	
	if current_heat > max_heat and not overheat_smoke.emitting:
		overheat_smoke.emitting = true


func shoot():
	current_spin_speed += spin_increase
	current_spin_speed = min(current_spin_speed, max_spin)
	
	if current_spin_speed < spin_needed:
		return
	
	if current_heat > max_heat:
		return
	
	if current_heat < max_heat:	
		current_heat += heat_increment
		super.shoot()
	
	if current_heat > max_heat:
		# Overheat! 
		current_heat *= 1.5
