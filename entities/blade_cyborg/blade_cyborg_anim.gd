extends AnimationTree

@onready var hitbox_locs2 = [$"../Node/hip2/torso/head2/head_a/head_hitbox",
$"../Node/hip2/torso/chest_hitbox",
$"../Node/hip2/crotch/hip_hitbox",
$"../Node/hip2/torso/arm_l2/arm_hitbox",
$"../Node/hip2/torso/arm_l2/forearm_l2/forearm_hitbox"
]
@export var glow_colour: Color = Color(0, 0, 0)
@export var glow_meshes: Array[MeshInstance3D] = []
@export var hitbox_locs: Array[MeshInstance3D]
@export var critbox_locs: Array[MeshInstance3D]
@export var shitbox_locs: Array[MeshInstance3D]

#the points that give crit damage
@onready var critbox_locs2 = [$"../Node/hip2/crotch/crit_hitbox"]

#the points that are resistent damage
@onready var shitbox_locs2 = [$"../Node/hip2/crotch/leg_r/thigh_hitbox_r",
$"../Node/hip2/crotch/leg_r/calf_r/calf_hitbox_r",
$"../Node/hip2/crotch/leg_l/thigh_hitbox_l",
$"../Node/hip2/crotch/leg_l/calf_l/calf_hitbox_l"]

@onready var entity = $"../../"


func create_hitboxes():
	var hitbox_script = load("res://scripts/entities/hitbox.gd")
	if hitbox_locs != []:
		for i in hitbox_locs: 
			i.visible = false
			i.create_trimesh_collision()
			i.get_child(0, false).set_collision_layer_value(1, false)
			i.get_child(0, false).set_collision_layer_value(4, true)
			i.get_child(0, false).set_collision_mask_value(1, false)
			i.get_child(0, false).set_script(hitbox_script)
			i.get_child(0, false).entity = entity
			i.get_child(0, false).hitbox_type = 0
	if critbox_locs != []:
		for i in critbox_locs: 
			i.visible = false
			i.create_trimesh_collision()
			i.get_child(0, false).set_collision_layer_value(1, false)
			i.get_child(0, false).set_collision_layer_value(4, true)
			i.get_child(0, false).set_collision_mask_value(1, false)
			i.get_child(0, false).set_script(hitbox_script)
			i.get_child(0, false).entity = entity
			i.get_child(0, false).hitbox_type = 1
	if shitbox_locs != []:
		for i in shitbox_locs:
			i.visible = false
			i.create_trimesh_collision()
			i.get_child(0, false).set_collision_layer_value(1, false)
			i.get_child(0, false).set_collision_layer_value(4, true)
			i.get_child(0, false).set_collision_mask_value(1, false)
			i.get_child(0, false).set_script(hitbox_script)
			i.get_child(0, false).entity = entity
			i.get_child(0, false).hitbox_type = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_hitboxes()
	update_model_lights()

func update_model_lights():
	pass
	#if glow_meshes != []:
		#for i in glow_meshes:
			#i.mesh.material.emission_enabled = true
			#i.mesh.material.emission = glow_colour

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_parameters(delta)

var jump_blend_amount: float = 0
var jump_space_amount: float = 0
var input_dir_amount: float
var run_scale_amount: float 
var crouch_blend_amount: float = 0
var movement_lerp_val: float = 0.05

var stun_lerp_val: float = 0.2
var stun_blend_amount: float = 0
var stun_blend_set: float = 0

var death_lerp_val: float = 0.5
var death_blend_amount: float = 0
var death_blend_set: float = 0


func update_parameters(delta: float):
	var speed = entity.velocity.length() / entity.SPEED_RUN
	if speed > 1:
		run_scale_amount = speed
		speed = 1
	else:
		run_scale_amount = 1
	#print(biped.input_dir)
	var backpedalmult = 1
	if entity.DESIRED_SPEED < 0:
		backpedalmult = -1
	set("parameters/run_scale/scale", run_scale_amount)
	jump_blend_amount = lerp(jump_blend_amount, float(!entity.stats.is_grounded), 0.5)
	jump_space_amount = lerp(jump_space_amount, entity.velocity.normalized().y, 0.1)
	set("parameters/walk_speed/blend_position", speed * backpedalmult)
	stun_blend_amount = lerp(stun_blend_amount, stun_blend_set, stun_lerp_val)
	set("parameters/stun_blend/blend_amount", stun_blend_amount)
	death_blend_amount = lerp(death_blend_amount, death_blend_set, death_lerp_val)
	set("parameters/death_blend/blend_amount", death_blend_amount)

func die():
	death_blend(true)
	#print("i'm dying :)")
	set("parameters/death_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	set("parameters/death_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	

func melee_oneshot(number: int):
	number += 1
	if number == 1:
		set("parameters/melee_1/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	elif number == 2:
		set("parameters/melee_2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	elif number == 3:
		set("parameters/melee_3/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		print("brokenmeleeanim")

func death_blend(truefalse: bool):
	death_blend_set = int(truefalse)


func stun_blend(truefalse: bool):
	stun_blend_set = int(truefalse)
