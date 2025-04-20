extends Node3D


@export var blood: PackedScene
@export var blood_amount: int
@export var blood_up_vel: float = 1
@export var velocity:Vector3
var blood_set: Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blood_set = []
	if blood == null:
		blood = load("res://blood_splatter_new.tscn")

var spread = 0.2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GAME.WORLD.loaded:
		var blood_mult = 0
		for i in blood_amount:
			var blood_instance = blood.instantiate()
			blood_set.append(blood_instance)
			blood_instance.starting_pos = global_position
			blood_instance.starting_vel = velocity + Vector3(randf_range(-spread, spread), randf_range(-spread, spread), randf_range(-spread, spread))
			
			
			GAME.WORLD.SCENERY.add_child(blood_instance)
			blood_mult += 1
			
		queue_free()
