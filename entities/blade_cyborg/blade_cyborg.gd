extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GRAVITY = 9.8

var targets = []
var is_grounded: bool = false
var grounded_timer
var team = 1

@onready var enemy_handler = $enemy_state
@onready var model_anim = $model/AnimationTree
@onready var view = $enemy_view
@onready var stats = $stats



func update_flags(delta):
	#grounded check
	if is_on_floor() and !stats.is_grounded:
		stats.is_grounded = true
		grounded_timer = 0
	elif !is_on_floor() and stats.is_grounded:
		stats.is_grounded = false
		grounded_timer = 0

func _physics_process(delta: float) -> void:
	update_flags(delta)
	if !stats.is_grounded:
		velocity.y -= delta * GRAVITY
		
	
	move_and_slide()
	
