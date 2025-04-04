extends Node3D

@export var item_type = ""
@export var item_name = ""
#@export var item_model: model
@export var item_effect = ""
var scene_path = "res://scenes/items/inventory_item.tscn"

var health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
