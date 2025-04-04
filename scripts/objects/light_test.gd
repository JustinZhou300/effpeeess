extends Node3D


@onready var unshaded_light = $unshaded
@onready var shaded_light = $shaded

@export var range: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unshaded_light.omni_range = range
	shaded_light.omni_range = range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
