extends GPUParticles3D

var timer
var spawn_position
var wall_normal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = 0
	emitting = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer >= lifetime:
		queue_free()
