extends Node2D

var noise

# Image size
const WIDTH = 256
const HEIGHT = 256

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
	noise.seed = 1 # Random seed
	noise.set_noise_type(2)
	noise.frequency = 0.03
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM    
	noise.cellular_distance_function = FastNoiseLite.DISTANCE_EUCLIDEAN     
	#noise.cellular_return_type = FastNoiseLite.RETURN_DISTANCE2_DIV   
	#noise.domain_warp_type = FastNoiseLite.DOMAIN_WARP_SIMPLEX_REDUCED      
	noise.fractal_octaves = 3
	noise.fractal_gain = 0.9
	noise.fractal_lacunarity = 2.0

	# Generate noise texture
	var image = noise.get_seamless_image(WIDTH, HEIGHT)
	image.resize(1500, 1500)
	var texture = ImageTexture.create_from_image(image)
	
	# Create a Sprite2D to display the texture
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.position = Vector2(0, 0) # Position at the top-left corner
	add_child(sprite)
