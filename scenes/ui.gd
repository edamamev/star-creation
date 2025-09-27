extends Control

@export var current_age = 1
@export var star_mass = 1
@export var max_age = 10
@export var star_luminosity = 1
@export var star_radius = 1
@export var star_density = 1
@export var star_temperature = 1
@export var star_habitable_zone = Vector2(1,1)
@export var star_life_possibility = "-"
@export var star_colour = Color(0,0,0)

var COLOUR_O = Color.from_rgba8(155, 176, 255)
var COLOUR_B = Color.from_rgba8(170, 191, 255)
var COLOUR_A = Color.from_rgba8(202, 215, 255)
var COLOUR_F = Color.from_rgba8(248, 247, 255)
var COLOUR_G = Color.from_rgba8(255, 244, 234)
var COLOUR_K = Color.from_rgba8(255, 210, 161)
var COLOUR_M = Color.from_rgba8(255, 204, 111)

signal colour_calculated(colour)
signal radius_calculated(radius)
signal luminosity_calculated(luminosity)


func _ready():
	calc_star_values()
	update_ui_values()
	pass
	

### On Change in Mass Input Value
func _on_mass_value_changed(value):
	star_mass = value
	calc_star_values()
	update_ui_values()

## On Change in Current Age Input Value
func _on_current_age_value_changed(value):
	current_age = value
	calc_star_values()
	update_ui_values()


func calc_star_values():
	calc_star_luminosity()
	calc_star_radius()
	calc_max_age()
	calc_star_density()
	calc_star_temperature()
	calc_habitable_zone()
	calc_life_possible()
	calc_colour()


func update_ui_values():
	current_age = clamp(current_age, 0, max_age)
	$Panel/Inputs/lblAge/sbAge.max_value = max_age
	
	
	# Text
	$Panel/Outputs/lblAgeMax/Label.text = str(snapped(max_age, 0.001)) + " Gyr"
	$Panel/Outputs/lblLum/Label.text = str(snapped(star_luminosity, 0.001)) + " SLum"
	$Panel/Outputs/lblRadius/Label.text = str(snapped(star_radius, 0.001)) + " SRad"
	$Panel/Outputs/lblDensity/Label.text = str(snapped(star_density, 0.001)) + " SDen"
	$Panel/Outputs/lblTemperature/Label.text = str(round(star_temperature)) + " K"
	$Panel/Outputs/lblHabitableMax/Label.text = str(snapped(star_habitable_zone.y, 0.001)) + " AU"
	$Panel/Outputs/lblHabitableMin/Label.text = str(snapped(star_habitable_zone.x, 0.001)) + " AU"
	$Panel/Outputs/lblLife/Label.text = star_life_possibility
	
	

## Only needs Star Mass
func calc_star_luminosity():
	if (star_mass < 0.43):
		star_luminosity = 0.23 * (star_mass ** 2.3)
	elif (star_mass < 2):
		star_luminosity = star_mass ** 4
	else:
		star_luminosity = 1.4 * (star_mass ** 3.5)
	luminosity_calculated.emit(star_luminosity)


## Only needs Star Mass
func calc_star_radius():
	if (star_mass < 1):
		star_radius = star_mass ** 0.8
	else:
		star_radius = star_mass ** 0.57
	radius_calculated.emit(star_radius)


## Needs Star Mass and Luminosity
func calc_max_age():
	max_age =  10 * (star_mass / star_luminosity)


## Needs Mass and Radius
func calc_star_density():
	star_density = star_mass / (star_radius ** 3)


## Needs Luminosity and Radius
func calc_star_temperature():
	star_temperature = 5776 * ((star_luminosity / (star_radius ** 2)) ** 0.25)


## Needs Luminosity
func calc_habitable_zone():
	star_habitable_zone = Vector2(
		(star_luminosity / 1.1)  ** 0.5,
		(star_luminosity / 0.53) ** 0.5
	)


## Needs Mass and Current Age
func calc_life_possible():
	if (star_mass >= 0.5 and star_mass <= 1.4):
		if (current_age >= 3.5):
			star_life_possibility = "Possible"
		else:
			star_life_possibility = "Star Too Young"
	else:
		star_life_possibility = "Not Possible"


## Needs Temperature
func calc_colour():
	if   (star_temperature <= 3900):
		star_colour = Color.BLACK.lerp(COLOUR_M, star_temperature / 3900)
		#star_colour = Vector3(0,0,0).lerp(COLOUR_M, star_temperature / 3900)
		print(str(star_colour) + " | " + str(star_temperature) + " | " + str(3900) + " | " + str(star_temperature / 3900))
	elif (star_temperature > 3900 and star_temperature <= 5300):
		#star_colour = Vector3(COLOUR_M).lerp(COLOUR_K, star_temperature / 5300)
		star_colour = COLOUR_M.lerp(COLOUR_K, (star_temperature - 3900) / 1400)
		print(str(star_colour) + " | " + str(star_temperature) + " | " + str(5300) + " | " + str(star_temperature / 5300))
	elif (star_temperature > 5300 and star_temperature <= 6000):
		#star_colour = Vector3(COLOUR_K).lerp(COLOUR_G, star_temperature / 6000)
		star_colour = COLOUR_K.lerp(COLOUR_G, (star_temperature - 5300) / 700)
		print(str(star_colour) + " | " + str(star_temperature) + " | " + str(6000) + " | " + str(star_temperature / 6000))
	elif (star_temperature > 6000 and star_temperature <= 7500):
		#star_colour = Vector3(COLOUR_G).lerp(COLOUR_F, star_temperature / 7300)
		star_colour = COLOUR_G.lerp(COLOUR_F, (star_temperature - 6000) / 1500)
		print(str(star_colour) + " | " + str(star_temperature) + " | " + str(7500) + " | " + str(star_temperature / 7500))
	elif (star_temperature > 7500 and star_temperature <= 10000):
		#star_colour = Vector3(COLOUR_F).lerp(COLOUR_A, star_temperature / 10000)
		star_colour = COLOUR_F.lerp(COLOUR_A, (star_temperature - 7500) / 2500)
		print(str(star_colour) + " | " + str(star_temperature) + " | " + str(10000) + " | " + str(star_temperature / 10000))
	elif (star_temperature > 10000 and star_temperature <= 33000):
		#star_colour = Vector3(COLOUR_A).lerp(COLOUR_B, star_temperature / 33000)
		star_colour = COLOUR_A.lerp(COLOUR_B, (star_temperature - 10000) / 23300)
		print(str(star_colour) + " | " + str(star_temperature) + " | " + str(33000) + " | " + str(star_temperature / 33000))
	else:
		star_colour = COLOUR_O
	colour_calculated.emit(star_colour)
