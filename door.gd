extends interactable
class_name door

# FUNC GODOT +++++++++++++++++++++++++++++++++++++++++++++++
@export var entProperties : Dictionary = {
	"power_grid" : "backup",
	"starting_state" : "door_closed"
}


func _func_godot_apply_properties(properties : Dictionary):
	entProperties = properties
	_ready()
# FUNC GODOT +++++++++++++++++++++++++++++++++++++++++++++++

@onready var model = $model
@onready var model_anim = $model/AnimationTree
@onready var door_area = $door_detection
@onready var nav_link = $nav_link
@onready var state_handler = $door_state
@onready var door_monitor_array = [$model/Node/door/bottom_door/screen_functional, 
$model/Node/door/bottom_door/screen_locked, 
$model/Node/door/bottom_door/screen_broken,
$model/Node/door/bottom_door/screen_dead
]

@onready var current_monitor_display: int = 0

var door_close_timer #time for the door to close when no entities are nearby

var is_open: bool
var power_grid: String

#the state the door will start in.
var starting_state: String


var has_init: bool = false
func init():
	#this function is like ready, but runs when map loads
	GAME.WORLD.POWERED.append(self)
	GAME.WORLD.LIGHTS.append(self)
	has_init = true

func _ready() -> void:
	super()
	power_grid = entProperties.power_grid
	starting_state = entProperties.starting_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GAME.WORLD.loaded and !has_init:
		init()
	
	#if stats.is_dead:
		#if current_monitor_display != 2:
			#set_door_monitor(2)
			#nav_link.enabled = false
	#elif !stats.is_powered:
		#if current_monitor_display != 3:
			#set_door_monitor(3)
			#nav_link.enabled = false
	#elif !is_open:
		#if check_area():
			#is_open = true
			#door_close_timer = 0
			#set_door_anim(true)
			#set_door_monitor(3)
			#nav_link.enabled = true
	#else:
		#if !check_area():
			#door_close_timer += delta
		#if  door_close_timer > 2:
			#is_open = false
			#set_door_anim(false)
			#set_door_monitor(2)
			#nav_link.enabled = true

		
			

func check_area():
	if door_area.has_overlapping_bodies():
		return true
		#var bodies = door_area.get_overlapping_bodies()
		#for i in bodies:
			#if 

func set_door_monitor(display_mode: int):
	#0 -functional, 1 - locked, 2 - broken, 3 -dead
	for i in door_monitor_array:
			i.visible = false
	print("setting_door_display_to: " + str(display_mode))
	if display_mode == 0:
		door_monitor_array[0].visible = true
		current_monitor_display = 0
	elif display_mode == 1:
		door_monitor_array[1].visible = true
		current_monitor_display = 1
	elif display_mode == 2:
		door_monitor_array[2].visible = true
		current_monitor_display = 2
	elif display_mode == 3:
		door_monitor_array[3].visible = true
		current_monitor_display = 3

func set_door_anim(openclose:bool):
	if openclose:
		model_anim.set("parameters/door_opening/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		model_anim.set("parameters/door_blend/blend_amount", 1)
	else:
		model_anim.set("parameters/door_closing/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		model_anim.set("parameters/door_blend/blend_amount", 0)
