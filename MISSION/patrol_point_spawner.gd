extends Node3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GAME.WORLD.loaded:
		var patrol_point_instance = load("res://MISSION/patrol_point.tscn").instantiate()
		patrol_point_instance.global_position = global_position
		GAME.WORLD.MISSION.PATROL_NODE.add_child(patrol_point_instance)
		GAME.WORLD.MISSION.PATROL_POINTS.append(patrol_point_instance)
		queue_free()
