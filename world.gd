extends Node3D

var MISSION
var ENTITIES# = $ENTITIES
var ITEMS# = $ITEMS
var player# = $ENTITIES/biped
var PROJECTILES# = $PROJECTILES
var SOUNDS# = $SOUNDS
var ENVIRONMENT
var SCENERY

var loaded = false


@onready var godot_map = $geometry/nav_mesh/FuncGodotMap
@onready var nav_map = $geometry/nav_mesh

#connect 

func _ready() -> void:
	MISSION = $MISSION
	ENTITIES = $ENTITIES
	ITEMS = $ITEMS
	player = $ENTITIES/biped
	PROJECTILES = $PROJECTILES
	SOUNDS = $SOUNDS
	ENVIRONMENT = $ENVIRONMENT
	SCENERY = $SCENERY
	
	GAME.WORLD = self
	godot_map.verify_and_build()
	nav_map.bake_navigation_mesh(true)

	#loaded = true

func _unhandled_input(_event):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()

func _process(delta: float) -> void:
	pass
	#print(Engine.get_frames_per_second())


func _on_func_godot_map_build_complete() -> void:
	loaded = true # Replace with function body.
