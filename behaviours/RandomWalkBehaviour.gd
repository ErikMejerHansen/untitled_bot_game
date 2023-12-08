class_name RandomWalkBehaviour
extends Behaviour


var noise = FastNoiseLite.new()
var time = 0.0

func _ready():
	noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX
	noise.seed = randi()
	noise.fractal_octaves = 4
	noise.frequency = 1.0 / 20.0

func _process(delta):
	time += delta

func _update_interest_map(interest_map:Array, strenght: float):
	for i in range(normalized_directions.size()):
		var direction = normalized_directions[i]
		var direction_weight = noise.get_noise_2dv(direction * time)
		var interest = remap(direction_weight, -1, 1, 0, 1) * strenght
		interest_map[i] = max(interest_map[i], interest)
