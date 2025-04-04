extends Node3D
class_name lamp

# FUNC GODOT +++++++++++++++++++++++++++++++++++++++++++++++
@export var entProperties : Dictionary = {
	"light_mode" : 0,
	"light_power" : 5,
	"light_range" : 20,
	"shadows_bool" : false,
	"light_colour" : Color(255, 160, 113)
}

func _func_godot_apply_properties(properties : Dictionary):
	entProperties = properties
	_ready()
# FUNC GODOT +++++++++++++++++++++++++++++++++++++++++++++++


enum light_mode {normal, flashing, flickering}

@export var flash_period = 0.1
@export var flicker_amount = 10
var flash_timer = 0
var light
@export var mode: light_mode = 0 #0 = normal, 1 = flashing, 2 = flickering

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flash_timer = 0
	light = $light
	light.light_energy = entProperties.light_power
	light.shadow_enabled = entProperties.shadows_bool
	mode = entProperties.light_mode
	light.omni_range = entProperties.light_range
	light.light_color = entProperties.light_colour


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mode != 0:
		flash_timer += delta
	if mode == 2:
		flicker()
	elif mode == 1:
		flash()
	elif mode == 0:
		normal()
	else:
		print("invalid light mode")

func flicker():
	var roll = randi_range(0,flicker_amount) #whether to turn off this frame
	if flash_timer >= flash_period and roll == 0:
		if light.visible == true:
			light.visible = false
		elif flash_timer >= flash_period:
			light.visible = true
		else:
			light.visible = true
		flash_timer = 0

func flash():
	if flash_timer >= flash_period:
		if light.visible == true:
			light.visible = false
		else:
			light.visible = true
		flash_timer = 0

func normal():
	if light.visible == false:
		light.visible = true
