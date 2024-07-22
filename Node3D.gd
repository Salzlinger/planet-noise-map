extends Node3D

@export var Star: PackedScene
@export var Planet: PackedScene

# metrics real scale
# size in Km
const SUN_R = 700000
const EARTH_R = 6300


const SUN_M = 333000 # Sun's mass in earthmasses
const EARTH_M = 5.972e24 # Earth's mass in kilograms

# distance
# Astronomische einheit AE in Km,
const AE = 149600000


# metrics in godot scale
const SCALE_FACTOR = 0.00071804003791251400178073929402303
# earth has 0.9% the size of the sun
const SUN_R_INSCALE = SUN_R * SCALE_FACTOR
const EARTH_R_INSCALE = EARTH_R * SCALE_FACTOR

# distance
const GD_AE = AE * SCALE_FACTOR

# mass
const GD_Earth_M = EARTH_M * SCALE_FACTOR
# in Km
const GD_SUN_M = GD_Earth_M * SUN_M

# hillsphere sonne erde
const hillsphere_sun_earth = GD_AE * pow((GD_Earth_M / (3 * GD_SUN_M)), 1/3)

func mean_density(body_mass, body_radius):
	var volume = (4.0 / 3.0) * PI * pow(body_radius, 3)
	var density = body_mass / volume
	return density
	
func calculate_roche_limit(primary_radius: float, primary_density: float, secondary_density: float, is_solid: bool) -> float:
	var roche_limit: float
	if is_solid:
		# Für starre (feste) Körper
		roche_limit = 1.26 * primary_radius * pow(primary_density / secondary_density, 1/3)
	else:
		# Für flüssige Körper
		roche_limit = 2.44 * primary_radius * pow(primary_density / secondary_density, 1/3)
	return roche_limit

func calculate_hillsphere(satelite_radius: float, primary_mass: float, secondary_mass: float) -> float:
	var test = secondary_mass / (3 * primary_mass)
	print(test)
	return satelite_radius * pow((secondary_mass / (3 * primary_mass)), 1/3)

	
var earth_density = mean_density(EARTH_M ,EARTH_R)
var sun_density = mean_density(SUN_M * EARTH_M, SUN_R)

var min_satelite_r = calculate_roche_limit(SUN_R, sun_density, earth_density, true)
var max_satelite_distance = calculate_hillsphere(min_satelite_r, SUN_M * EARTH_M, EARTH_M)


# Called when the node enters the scene tree for the first time.
func _ready():
	print("min_satelite_r ", min_satelite_r * SCALE_FACTOR)
	print("max_satelite_distance ", max_satelite_distance * SCALE_FACTOR)


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

	
	
