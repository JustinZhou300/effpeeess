extends weapon_gun
class_name flashlight

# Called when the node enters the scene tree for the first time.

@export var light: SpotLight3D
var light_on: bool = false

var battery: float = 100
var battery_drain_rate = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(battery)
	if battery <= 0:
		light.visible = false
		light_on = false
	elif light_on:
		battery -= delta * battery_drain_rate
	
	if !light_on and light.visible == true:
		light.visible = false
	elif light_on and light.visible == false:
		light.visible = true

func primary_fire():
	if !light_on and battery > 0:
		light_on = true
	else:
		light_on = false

func secondary_fire():
	pass

func proc_reload():
	battery = 100
