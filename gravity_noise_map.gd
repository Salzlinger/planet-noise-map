extends Node3D

var noise

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the noise generator
	noise = FastNoiseLite.new()

	# Configure the noise properties
	noise.seed = randi() # Random seed
	noise.set_noise_type(0)
	noise.frequency = 0.05
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves  = 4
	noise.fractal_gain = 0.5
	noise.fractal_lacunarity = 2.0

	# Sample the noise
	print("Values:")
	print(noise.get_noise_2d(1.0, 1.0))
	print(noise.get_noise_3d(0.5, 3.0, 15.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
