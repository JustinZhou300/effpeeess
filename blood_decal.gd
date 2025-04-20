extends Decal

var texture: Texture
var start_size = 0.1
var end_size = 2
var norm: Vector3
@onready var floor_textures = [load("res://assets/textures/particles/blood_decal.png"),
load("res://assets/textures/particles/blood_decal2.png"),
load("res://assets/textures/particles/blood_decal3.png")]

var floor_aligned: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_albedo = floor_textures[randi() % floor_textures.size()]
	size = Vector3(start_size, 0.1, start_size)
	end_size = randf_range(0.8, 1.2)
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if size != Vector3(end_size, 0.1, end_size):
		size = lerp(size, Vector3(end_size, 0.1, end_size), 0.1)
		
	print("norm is: " + str(norm))
	if !floor_aligned and norm != null:
		print("code run")
		look_at(global_position + norm, Vector3.UP)
		rotate(norm, randf_range(0, 2*PI))
		floor_aligned = true
