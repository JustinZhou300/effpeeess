extends WorldEnvironment

var star 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	star = $star

var size: float = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#star.rotation.x += -delta * 0.1
	environment.sky.sky_material.set("shader_parameter/astro_scale", size)
	size = lerp(size, 0.1, 0.005)
	#star.light_energy = lerp(star.light_energy, 10.0, 0.005)
