extends Node3D

var time_alive #in seconds
var lifetime = 1/60 #in seconds

var firing_pos: Vector3
var firing_rot: Vector3
var hit_pos: Vector3
var beam
var dist

var colour: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	beam = $beam
	beam.mesh.height = dist
	beam.mesh.material.albedo_color = colour
	beam.mesh.material.emission = colour
	beam.position.z = -dist/2
	global_position = firing_pos
	global_rotation = firing_rot
	if hit_pos:
		look_at(hit_pos)
	time_alive = 0 # Replace with function body.
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("rotation: " + str(rotation))
	time_alive += delta
	#print(global_position)
	if time_alive > lifetime:
		queue_free()
