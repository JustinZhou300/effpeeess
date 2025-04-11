extends Decal

var texture: Texture
var end_size = 1
@onready var floor_textures = [load("res://assets/textures/particles/blood_decal.png"),
load("res://assets/textures/particles/blood_decal2.png"),
load("res://assets/textures/particles/blood_decal3.png")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_albedo = floor_textures[randi() % floor_textures.size()]
	size = Vector3(0.1, 0.1, 0.1)
	end_size = randf_range(1, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if size != Vector3(1, 0.1, 1):
		size = lerp(size, Vector3(1, 0.1, 1), 0.1)
