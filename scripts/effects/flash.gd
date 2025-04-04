extends Node3D

var time_alive #in seconds
var lifetime #in seconds

var firing_pos: Vector3
var flash
var colour: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	flash = $muzzle_flash
	lifetime = flash.lifetime
	flash.emitting = true
	global_position = firing_pos
	time_alive = 0 # Replace with function body.
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_alive += delta
	if time_alive > lifetime:
		queue_free()
