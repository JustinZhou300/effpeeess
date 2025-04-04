extends Node



var PATROL_NODE
var PATROL_POINTS = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PATROL_NODE = $PATROL


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func find_closest_patrol_point(position: Vector3):
	var closest_point = null
	var closest_distance = 999999
	for i in PATROL_POINTS:
		if i.global_position.distance_to(position) < closest_distance:
			closest_distance = i.global_position.distance_to(position)
			closest_point = i
	return closest_point
