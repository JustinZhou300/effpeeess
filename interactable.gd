extends Node3D
class_name interactable

var stats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	stats = $stats


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	pass
