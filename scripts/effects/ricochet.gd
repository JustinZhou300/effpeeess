extends Node3D

var spark
var light
var timer
var lifetime
var spawn_position
var wall_normal
var colour: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	light = $light
	spark = $spark
	light.light_color = colour
	spark.draw_pass_1.material.albedo_color = colour
	spark.draw_pass_1.material.emission = colour
	lifetime = spark.lifetime
	timer = 0
	spark.emitting = true
	global_position = spawn_position + (wall_normal * 0.05)
	if wall_normal == Vector3(0, 1, 0):
		look_at(global_position + wall_normal, Vector3(1,0,0))
	else:
		look_at(global_position + wall_normal, Vector3(0,1,0))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer >= lifetime:
		queue_free()
