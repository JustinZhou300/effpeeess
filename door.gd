extends Node3D

@onready var model = $model
@onready var model_anim = $model/AnimationTree
@onready var door_area = $door_detection

@onready var door_monitor_array = [$model/Node/door/bottom_door/screen_functional, 
$model/Node/door/bottom_door/screen_locked, 
$model/Node/door/bottom_door/screen_broken,
$model/Node/door/bottom_door/screen_dead
]

var door_close_timer #time for the door to close when no entities are nearby

var mode: int #0 - closed, 1 - open, 2 - locked, 3 - broken

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mode == 0:
		if check_area():
			mode = 1
			door_close_timer = 0
			set_door_anim(true)
			set_door_monitor(0)
	elif mode == 1:
		if !check_area():
			door_close_timer += delta
		if  door_close_timer > 2:
			mode = 0
			set_door_anim(false)
			set_door_monitor(1)

func check_area():
	if door_area.has_overlapping_bodies():
		return true
		#var bodies = door_area.get_overlapping_bodies()
		#for i in bodies:
			#if 

func set_door_monitor(display_mode):
	for i in door_monitor_array:
			i.visible = false
	
	if mode == 0:
		door_monitor_array[0].visible = true
	elif mode == 1:
		door_monitor_array[1].visible = true
	elif mode == 2:
		door_monitor_array[2].visible = true
	elif mode == 3:
		door_monitor_array[3].visible = true

func set_door_anim(openclose:bool):
	if openclose:
		model_anim.set("parameters/door_opening/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		model_anim.set("parameters/door_blend/blend_amount", 1)
	else:
		model_anim.set("parameters/door_closing/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		model_anim.set("parameters/door_blend/blend_amount", 0)
