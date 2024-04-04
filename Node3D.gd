extends Node3D

@export var Star: PackedScene
@export var Planet: PackedScene

# metrics real scale
# size in Km
const SUN_R = 700000
const EARTH_R = 6300

# masses in earthmasses
const SUN_M = 333000

# metrics in godot scale
# earth has 0.9% the size of the sun
const SUN_R_INSCALE = 500
const EARTH_R_INSCALE = 4.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var planets = []  # List to store all planets

func _process(delta):
	for planet in planets:
		# Update the orbit angle
		var angular_velocity = 0.1  # Adjust this value as needed
		planet.orbit_angle += angular_velocity * delta
		
		# Update the planet's position
		planet.position.x = planet.orbit_radius * cos(planet.orbit_angle)
		planet.position.z = planet.orbit_radius * sin(planet.orbit_angle)
	
func normalverteilte_zufallszahl(mittelwert: float, standardabweichung: float, n: int) -> float:
	var summe = 0.0
	for i in range(n):
		summe += randf()  # randf() gibt eine Zufallszahl zwischen 0.0 und 1.0 zurück
		# Zentrale Grenzwerttheorem-Anwendung, um annähernde Normalverteilung zu erhalten
	return mittelwert + standardabweichung * (summe - n / 2.0) / (sqrt(n / 12.0))
	

func generiere_werte(mittelwert: float, standardabweichung: float, untergrenze: float, obergrenze: float) -> float:

	var wert = normalverteilte_zufallszahl(mittelwert, standardabweichung, 12)
	if wert <= untergrenze and !wert >= obergrenze: 
		wert = generiere_werte(3, 5, 1, 10)
	return wert
	
func create_star():
	var star_diameter = SUN_R_INSCALE * 2
	var star = Star.instantiate()
	star.scale = Vector3(star_diameter, star_diameter, star_diameter)
	return star
	
func create_planet(orbit_radius, angle):
	var planet_diameter = EARTH_R_INSCALE * 2
	var planet = Planet.instantiate()
	# Set size or scale if needed
	planet.scale = Vector3(planet_diameter, planet_diameter, planet_diameter)
	
	# Store orbit information in the planet instance
	planet.orbit_radius = orbit_radius
	planet.orbit_angle = angle
	
	# Set initial position
	planet.position.x = orbit_radius * cos(angle)
	planet.position.z = orbit_radius * sin(angle)
	
	return planet

func create_star_system():
	print("creating star system")
	var star = create_star()
	add_child(star)
	var system_body_number = int(generiere_werte(3, 2, 1, 10))
	print(system_body_number)
	var last_body_position = 0
	for i in range(system_body_number):
# Calculate orbit radius and initial angle
		var orbit_radius = star.scale.x * 0.5 + randf_range(10, 100)
		var initial_angle = randf_range(0, 2 * PI)
		
		# Create planet with orbit information
		var planet = create_planet(orbit_radius, initial_angle)
		planets.append(planet)  # Add the planet to the list for tracking
		add_child(planet)


func _on_button_pressed():
	print("button pressed")
	create_star_system()

	
	
