extends RayCast3D

var parent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GAME.WORLD.loaded:
		if is_colliding():
			parent.global_position = get_collision_point()
		queue_free()
