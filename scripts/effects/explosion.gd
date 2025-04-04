extends Node3D

var debris
var fire
var smoke
var lifetime: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debris = $debris
	fire = $fire
	smoke = $smoke
	lifetime = 0
	debris.emitting = true
	fire.emitting = true
	smoke.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime += delta
	if lifetime > smoke.lifetime:
		queue_free()
