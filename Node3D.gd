extends Node3D

@export var Star: PackedScene
@export var Planet: PackedScene

# metrics real scale
# size in Km
const SUN_R = 700000
const EARTH_R = 6300


const SUN_M = 333000 # Sun's mass in earthmasses
const EARTH_M = 5.972e24 # Earth's mass in kilograms

const STAR_MASS_MAX = SUN_M * 300
const STAR_MASS_MIN = SUN_M * 0.07
const STAR_MASS_AVARAGE = SUN_M * 0.5
const STAR_MASS_MEDIAN = SUN_M * 0.2

# distance
# Astronomische einheit AE in Km,
const AU = 149600000


# metrics in godot scale
#const SCALE_FACTOR = 0.00071804003791251400178073929402303
const SCALE_FACTOR = 0.0000007
const VISABILITY_SCALEING_FACTOR = 500
# earth has 0.9% the size of the sun
const SUN_R_INSCALE = SUN_R * SCALE_FACTOR
const EARTH_R_INSCALE = EARTH_R * SCALE_FACTOR

# self approxiamtion
const EXO_SIZE_MAX = SUN_R_INSCALE / 2
const EXO_SIZE_MIN = EARTH_R_INSCALE * 0.5
const EXO_SIZE_MEDIAN = EARTH_R_INSCALE * 10


# distance
const GD_AU = AU * SCALE_FACTOR

# max distance exoplanet - self aproximated ~ 2 * Pluto max distance to Sun
const EXO_DISTANCE_MAX = GD_AU * 100
const EXO_DISTANCE_MEDIAN = GD_AU * 8.5

# mass in Kg
const GD_Earth_M = EARTH_M * SCALE_FACTOR
const GD_SUN_M = GD_Earth_M * SUN_M

# self approxiamtion
const EXO_MASS_MAX = GD_Earth_M * 1000
const EXO_MASS_MIN = GD_Earth_M * 0.1
const EXO_MASS_MEDIAN = GD_Earth_M * 340

# hillsphere sonne erde
const hillsphere_sun_earth = GD_AU * pow((GD_Earth_M / (3 * GD_SUN_M)), 1/3)

func mean_density(body_mass, body_radius):
	var volume = (4.0 / 3.0) * PI * pow(body_radius, 3)
	var density = body_mass / volume
	return density

# minimum distance a body can approach a larger body without beeing distroyed
func calculate_roche_limit(primary_radius: float, primary_density: float, satelite_density: float, is_solid: bool) -> float:
	var roche_limit: float
	if is_solid:
		# Für starre (feste) Körper
		roche_limit = 1.26 * primary_radius * pow(primary_density / satelite_density, 1/3)
	else:
		# Für flüssige Körper
		roche_limit = 2.44 * primary_radius * pow(primary_density / satelite_density, 1/3)
	return roche_limit

# sphere where a body can hold a satalite
func calculate_hillsphere(satelite_radius: float, primary_mass: float, secondary_mass: float) -> float:
	var test = secondary_mass / (3 * primary_mass)
	print(test)
	return satelite_radius * pow((secondary_mass / (3 * primary_mass)), 1/3)

	
var earth_density = mean_density(EARTH_M ,EARTH_R)
var sun_density = mean_density(SUN_M * EARTH_M, SUN_R)

var min_satelite_r = calculate_roche_limit(SUN_R, sun_density, earth_density, true)
var max_satelite_distance = calculate_hillsphere(min_satelite_r, SUN_M * EARTH_M, EARTH_M)

var planets = []  # List to store all planets

# Called when the node enters the scene tree for the first time.
func _ready():
	print("started App")
	print("ABOVE EXO_SIZE_MAX: ", EXO_SIZE_MAX)
	print("ABOVE EXO_SIZE_MIN: ", EXO_SIZE_MIN)
	print("ABOVE EXO_SIZE_MEDIAN: ", EXO_SIZE_MEDIAN)
	print("ABOVE EARTH_R_INSCALE: ", EARTH_R_INSCALE)
	print("ABOVE SUN_R_INSCALE: ", SUN_R_INSCALE)

		


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	for planet in planets:
		# Update the orbit angle
		var angular_velocity = 0.1  # Adjust this value as needed
		planet.orbit_angle += angular_velocity * delta
		
		var posX = planet.orbit_radius * cos(planet.orbit_angle)
		var posY = planet.orbit_radius * sin(planet.orbit_angle)
		#print("posX", posX)
		#print("posX", posY)
		
		# Update the planet's position
		#planet.position.x = posX
		#planet.position.z = posY
	
func normaly_distributed_random_numbers(mittelwert: float, standardabweichung: float, n: int) -> float:
	var summe = 0.0
	for i in range(n):
		summe += randf()  # randf() gibt eine Zufallszahl zwischen 0.0 und 1.0 zurück
		# Zentrale Grenzwerttheorem-Anwendung, um annähernde Normalverteilung zu erhalten
	return mittelwert + standardabweichung * (summe - n / 2.0) / (sqrt(n / 12.0))
	

func generate_number(mittelwert: float, standardabweichung: float, untergrenze: float, obergrenze: float) -> float:
	var wert = normaly_distributed_random_numbers(mittelwert, standardabweichung, 12)
	if wert <= untergrenze and !wert >= obergrenze: 
		wert = generate_number(3, 5, 1, 10)
	return wert
	
func create_star():
	print("SUN_R_INSCALE", SUN_R_INSCALE)
	var star_diameter = SUN_R_INSCALE * 2 * VISABILITY_SCALEING_FACTOR
	print("star_diameter", star_diameter)
	var star = Star.instantiate()
	
	star.scale = Vector3(star_diameter, star_diameter, star_diameter)
	return star
	
func create_planet(orbit_radius, angle, planet_diameter):
	var planet = Planet.instantiate()
	print("planet_diameter", planet_diameter)
	# Set size or scale if needed
	planet.scale = Vector3(planet_diameter, planet_diameter, planet_diameter)
	
	# Store orbit information in the planet instance
	planet.orbit_radius = orbit_radius
	planet.orbit_angle = angle
	
	# Set initial position
	planet.position.x = orbit_radius * cos(angle)
	planet.position.z = orbit_radius * sin(angle)
	
	return planet
	
	
func get_planet_orbit(star_diameter, rochelimit_parent_star):
	#mittelwert: 8.5, standardabweichung: 3, untergrenze: roche_limit_star, obergrenze: EXO_DISTANCE_MAX
	return star_diameter * 0.5 + generate_number(EXO_DISTANCE_MEDIAN , 3 * GD_AU, rochelimit_parent_star ,EXO_DISTANCE_MAX)

func create_star_system():
	print("creating star system")
	var star = create_star()
	add_child(star)
	# mittelwert: 3, standardabweichung: 2, untergrenze: 0, obergrenze: 12
	var system_body_number = int(generate_number(3, 2, 0, 12))
	print(system_body_number)
	for i in range(system_body_number):
# Calculate orbit radius and initial angle
			# at the moment only terrestial bodys for testing purposes
	
		var exo_radius = generate_number(EXO_SIZE_MEDIAN, 200 * SCALE_FACTOR, EXO_SIZE_MIN, EXO_SIZE_MAX)
		var exo_diameter = exo_radius * 2 * VISABILITY_SCALEING_FACTOR
		var exo_mass = generate_number(EXO_MASS_MEDIAN, GD_Earth_M, EXO_MASS_MIN, EXO_MASS_MAX)
		
		#body_mass, body_radius
		var exo_mean_density = mean_density(exo_mass, exo_radius)
		var star_mean_density = mean_density(GD_SUN_M * GD_Earth_M ,SUN_R_INSCALE)
		
		#primary_radius: float, primary_density: float, satelite_density: exo_mean_density, is_solid: true
		var rochelimit_parent_star = 	calculate_roche_limit(SUN_R_INSCALE, star_mean_density, exo_mean_density, true)
		print("rochelimit_parent_star: ", rochelimit_parent_star)
		var orbit_radius = get_planet_orbit(star.scale.x, rochelimit_parent_star)
		print("orbit: ", orbit_radius)
		var initial_angle = randf_range(0, 2 * PI)
		# Create planet with orbit information
		var planet = create_planet(orbit_radius, initial_angle, exo_diameter)
		planets.append(planet)  # Add the planet to the list for tracking
		add_child(planet)


func _on_button_pressed():
	print("button pressed")
	create_star_system()
	for planet in planets:
		print("PLANET POS: ", planet.get_index())
		print("posX: ", planet.position.x)
		print("posY: ", planet.position.z)
		print("posz: ", planet.position.z)

	
	
