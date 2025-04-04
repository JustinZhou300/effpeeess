extends Node3D

#visuals
var model
var effect
var light

#parameters
@export var colour: Color = Color(255, 255, 0)
@export var speed: float = 1
@export var size: float = 1

#code shit
var direction
var initial_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	model = $model
	effect = $effect
	light = $light
	model.mesh.material.albedo_color = colour
	effect.draw_pass_1.material.set_albedo(colour)
	light.light_color = colour
	global_position = initial_position
	visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += speed * direction * delta
