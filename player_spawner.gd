extends Node3D

#object that spawns the player

var player_scene: PackedScene
var player_number: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_scene = load("res://scenes/biped/biped.tscn")
	
	
	#queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GAME.WORLD.loaded:
		var player = player_scene.instantiate()
		
		GAME.WORLD.ENTITIES.add_child(player)
		player.global_position = global_position
		player.global_rotation = Vector3(0, 0, 0)
		queue_free()
