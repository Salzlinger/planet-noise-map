extends Node3D
var noise

func _ready():
	# Initialize the noise generator
	#noise = FastNoiseLite.new()
	#noise.seed = randi() # Random seed
	#noise.set_noise_type(0)
	#noise.frequency = 0.05
	#noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	#noise.fractal_octaves = 4
	#noise.fractal_gain = 0.5
	#noise.fractal_lacunarity = 2.0
	noise = FastNoiseLite.new()
	noise.seed = randi() # Random seed
	noise.set_noise_type(0)
	noise.frequency = 0.02
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves = 4
	noise.fractal_gain = 0.5
	noise.fractal_lacunarity = 2.0

	# Generate noise texture
	
	var texture = NoiseTexture3D.new()
	texture.noise = noise
	await texture.changed
	var data = texture.get_data()
	
	# Create a Sprite2D to display the texture
	var sprite = Sprite3D.new()
	sprite.position = Vector2(0, 0) # Position at the top-left corner
	add_child(sprite)
