extends Node3D

var hole
var spawn_position
var wall_normal

var timer
var lifetime = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hole = $hole
	global_position = spawn_position + (0.02 * wall_normal)
	if wall_normal == Vector3(0, 1, 0):
		look_at(global_position + wall_normal, Vector3(1,0,0))
	elif wall_normal == Vector3(0, -1, 0):
		look_at(global_position + wall_normal, Vector3(1, 0, 0))
	else:
		look_at(global_position + wall_normal, Vector3(0,1,0))
	timer = 0 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer >= lifetime:
		queue_free()
