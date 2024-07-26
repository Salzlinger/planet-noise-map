extends Node3D
@export var Star: PackedScene
# constants
var seedValue = 12345
var number_of_stars = 100

# random gen
var rng = RandomNumberGenerator.new()


var star_points = []


func _ready():
	print(rng)
	rng.seed = seedValue
	generate_star_points(number_of_stars)

	for point in star_points:
		print(point)
		var star = Star.instantiate()
		star.scale = Vector3(100, 100, 100)
		star.position = point
		add_child(star)


func generate_star_points(star_amount):
	# Space Dimentions
	var min_x = -1000
	var max_x = 1000
	var min_y = -1000
	var max_y = 1000
	var min_z = -1000
	var max_z = 1000
	
	for i in range(star_amount):
		print(i)
		var x = rng.randf_range(min_x, max_x)
		print(x)
		var y = rng.randf_range(min_y, max_y)
		print(y)
		var z = rng.randf_range(min_z, max_z)
		print(z)
		star_points.append(Vector3(x, y, z))

