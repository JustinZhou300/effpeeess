extends AnimationTree

@onready var model = $"../Node"
@export var model_mode:int
#@onready var biped = $"../../../"
var biped
var desired_leg_angle: float
var desired_torso_angle: float

@onready var head_pos = $"../Node/hip2/torso/head2/head_a/viewpoint"
@onready var arm_pos = $"../Node/hip2/torso/arm_r2"
@onready var gun_loc = $"../Node/hip2/torso/arm_r2/forearm_r2/hand_r/gun_loc_r"

#stow locations
@onready var stow0_loc = $"../Node/hip2/crotch/leg_l/stow_0"
@onready var stow1_loc = $"../Node/hip2/torso/stow_1"
@onready var stow2_loc = $"../Node/hip2/crotch/leg_r/stow_2"


@onready var hitbox_locs = [$"../Node/hip2/torso/hitbox_chest", 
$"../Node/hip2/crotch/hitbox_hip", 
$"../Node/hip2/torso/arm_l2/hitbox_arm_l", 
$"../Node/hip2/torso/arm_l2/forearm_l2/hitbox_forearm_l", 
$"../Node/hip2/torso/arm_r2/hitbox_arm_r", 
$"../Node/hip2/torso/arm_r2/forearm_r2/hitbox_forearm_r",
$"../Node/hip2/crotch/leg_l/hitbox_thigh_l",
$"../Node/hip2/crotch/leg_l/calf_l/hitbox_calf_l",
$"../Node/hip2/crotch/leg_r/calf_r/hitbox_calf_r",
$"../Node/hip2/crotch/leg_r/hitbox_thigh_r"]

@onready var critbox_locs = [$"../Node/hip2/torso/head2/hitbox_head"]

#the points that are resistent damage
@onready var shitbox_locs = []

@onready var hands_r = [$"../Node/hip2/torso/arm_r2/forearm_r2/hand_r/hand_r_hold",
$"../Node/hip2/torso/arm_r2/forearm_r2/hand_r/hand_r_fist",
$"../Node/hip2/torso/arm_r2/forearm_r2/hand_r/hand_r_palm"]

@onready var hands_l = [$"../Node/hip2/torso/arm_l2/forearm_l2/hand_l/hand_l_hold",
$"../Node/hip2/torso/arm_l2/forearm_l2/hand_l/hand_l_fist",
$"../Node/hip2/torso/arm_l2/forearm_l2/hand_l/hand_l_palm"]

func set_hands(position: String):
	for i in hands_r:
		i.visible = false
	for i in hands_l:
		i.visible = false
	if position == "hold":
		hands_l[0].visible = true
		hands_r[0].visible = true
	elif position == "fist":
		hands_l[1].visible = true
		hands_r[1].visible = true
	elif position == "palm":
		hands_l[2].visible = true
		hands_r[2].visible = true


func create_hitboxes():
	var hitbox_script = load("res://scripts/entities/hitbox.gd")
	if hitbox_locs != []:
		for i in hitbox_locs: 
			i.visible = false
			i.create_trimesh_collision()
			i.get_child(0, false).set_collision_layer_value(1, false)
			i.get_child(0, false).set_collision_layer_value(4, true)
			i.get_child(0, false).set_script(hitbox_script)
			i.get_child(0, false).entity = biped
			i.get_child(0, false).hitbox_type = 0
	if critbox_locs != []:
		for i in critbox_locs: 
			i.visible = false
			i.create_trimesh_collision()
			i.get_child(0, false).set_collision_layer_value(1, false)
			i.get_child(0, false).set_collision_layer_value(4, true)
			i.get_child(0, false).set_script(hitbox_script)
			i.get_child(0, false).entity = biped
			i.get_child(0, false).hitbox_type = 1
	if shitbox_locs != []:
		for i in shitbox_locs:
			i.visible = false
			i.create_trimesh_collision()
			i.get_child(0, false).set_collision_layer_value(1, false)
			i.get_child(0, false).set_collision_layer_value(4, true)
			i.get_child(0, false).set_script(hitbox_script)
			i.get_child(0, false).entity = biped
			i.get_child(0, false).hitbox_type = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if model_mode == 0:
		biped = $"../../../"
	elif model_mode == 1:
		biped = $"../../../../"
	
	#create hitboxes:
	create_hitboxes()
	
	#set hands to "hold"
	set_hands("hold")
	
	#hide head from view but still generate shadows
	var head_node = $"../Node/hip2/torso/head2/head_a"
	var hat_node = $"../Node/hip2/torso/head2/head_a/HAT"
	var neck_mesh = $"../Node/hip2/torso/neck"
	
	for i in head_node.get_children():
		if i.get_class() == "MeshInstance3D":
			i.set_cast_shadows_setting(3)
	
	#for i in hat_node.get_children():
		#if i.get_class() == "MeshInstance3D":
			#i.set_cast_shadows_setting(3)
	
	neck_mesh.set_cast_shadows_setting(3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_parameters(delta)

func _physics_process(delta: float) -> void:
	biped.arm_wall_hit.global_position = arm_pos.global_position

var jump_blend_amount: float = 0
var jump_space_amount: float = 0
var input_dir_amount: float
var run_scale_amount: float 
var crouch_blend_amount: float = 0
var movement_lerp_val: float = 0.05

var slide_lerp_val: float = 0.5
var slide_blend_amount: float = 0
var slide_blend_set: float = 0

var walled_lerp_val: float = 0.2
var walled_blend_amount: float = 0
var walled_blend_set: float = 0

var sprint_lerp_val: float = 0.1
var sprint_blend_amount: float = 0
var sprint_blend_set: float = 0

var lean_blend_amount: float = 0
var lean_lerp_val = 0.1

var unarmed_lerp_val: float = 0.5
var unarmed_blend_amount: float = 0
var unarmed_blend_set: float = 0

var weapon_lerp_val: float = 0.2
var weapon_blend_amount: float = 0
var weapon_blend_set: float = 0

var stun_lerp_val: float = 0.2
var stun_blend_amount: float = 0
var stun_blend_set: float = 0

var death_lerp_val: float = 0.2
var death_blend_amount: float = 0
var death_blend_set: float = 0

var overheat_lerp_val: float = 0.2
var overheat_blend_amount: float = 0
var overheat_blend_set: float = 0

func update_parameters(delta: float):
	var speed = biped.velocity.length() / biped.stats.SPEED_RUN
	var crouch_speed = biped.velocity.length() / biped.stats.SPEED_CROUCH
	if speed > 1:
		run_scale_amount = speed
		speed = 1
	else:
		run_scale_amount = 1
	#print(biped.input_dir)
	var backpedalmult = 1
	if biped.input_dir.y > 0:
		backpedalmult = -1
	set("parameters/run_scale/scale", run_scale_amount)
	jump_blend_amount = lerp(jump_blend_amount, float(!biped.stats.is_grounded), 0.5)
	jump_space_amount = lerp(jump_space_amount, biped.velocity.normalized().y, 0.1)
	set("parameters/walk_speed/blend_position", speed * backpedalmult)
	set("parameters/crouch_speed/blend_position", crouch_speed * backpedalmult)
	#update_visuals()
	
	#update_jump
	set("parameters/jump_blend/blend_amount", jump_blend_amount)
	set("parameters/jump_space/blend_position", Vector2(jump_space_amount, crouch_blend_amount))
	
	
	
	#model update:
	if biped.input_dir:
		if biped.input_dir.y > 0:
			input_dir_amount = lerp(input_dir_amount, -biped.input_dir.normalized().x, movement_lerp_val)
		else:
			input_dir_amount = lerp(input_dir_amount, biped.input_dir.normalized().x, movement_lerp_val)
		
	if biped.input_dir == Vector2(0, 0):
		input_dir_amount = lerp(input_dir_amount, float(0), movement_lerp_val)
	set_leg_angle(input_dir_amount)
	set_torso_angle(biped.playerViewCamera.rotation.x)
	#print(playerViewCamera.rotation.x)
	
	crouch_blend_amount = lerp(crouch_blend_amount, float(biped.stats.is_crouched), 0.1)
	set("parameters/crouch_blend/blend_amount", crouch_blend_amount)
	
	#slide update:
	slide_blend_amount = lerp(slide_blend_amount, slide_blend_set, slide_lerp_val)
	#print(slide_blend_amount)
	set("parameters/slide_blend/blend_amount", slide_blend_amount)
	
	walled_blend_amount = lerp(walled_blend_amount, walled_blend_set, walled_lerp_val)
	#print(walled_blend_amount)
	set("parameters/walled_blend/blend_amount", walled_blend_amount)
	
	sprint_blend_amount = lerp(sprint_blend_amount, sprint_blend_set, sprint_lerp_val)
	#print(walled_blend_amount)
	set("parameters/sprint_blend/blend_amount", sprint_blend_amount)
	
	lean_blend_amount = lerp(lean_blend_amount, biped.desired_lean, lean_lerp_val)
	set("parameters/lean_space/blend_position", lean_blend_amount)
	
	unarmed_blend_amount = lerp(unarmed_blend_amount, unarmed_blend_set, unarmed_lerp_val)
	set("parameters/unarmed_blend/blend_amount", unarmed_blend_amount)
	
	weapon_blend_amount = lerp(weapon_blend_amount, weapon_blend_set, weapon_lerp_val)
	set("parameters/weapon_blend/blend_amount", weapon_blend_amount)
	
	stun_blend_amount = lerp(stun_blend_amount, stun_blend_set, stun_lerp_val)
	set("parameters/stun_blend/blend_amount", stun_blend_amount)
	
	overheat_blend_amount = lerp(overheat_blend_amount, overheat_blend_set, overheat_lerp_val)
	set("parameters/overheat_blend/blend_amount", overheat_blend_amount)
	
	death_blend_amount = lerp(death_blend_amount, death_blend_set, death_lerp_val)
	set("parameters/death_blend/blend_amount", death_blend_amount)

func update_speed():
	pass
	

func set_leg_angle(amount):
	#angle in as degrees
	set("parameters/legs_turn/blend_position", amount)
	#model.rotation.y = angle + deg_to_rad(180)
	#Sdesired_leg_angle = angle + deg_to_rad(180)

func set_torso_angle(amount):
	set("parameters/torso_pos/blend_position", amount)
	#set("parameters/head_pos/blend_position", amount)
	#set("parameters/arm_pos/blend_position", amount)

func set_slide(slide_bool: bool):
	slide_blend_set = float(slide_bool)

func fire_weapon():
	set("parameters/gun_fire/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func set_walled(walled_bool: bool):
	walled_blend_set = float(walled_bool)

func set_sprint(sprint_bool: bool):
	sprint_blend_set = float(sprint_bool)

func reload():
	set("parameters/gun_reload/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func draw():
	set("parameters/gun_draw/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
func stow():
	set("parameters/gun_stow/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func wall_jump():
	set("parameters/wall_jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

var punch_side = 1
func punch():
	punch_side *= -1
	set("parameters/punch_space/blend_position", punch_side)
	set("parameters/punch_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func die():
	set("parameters/death_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func mantle():
	set("parameters/mantle_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func throw():
	set("parameters/throw_oneshot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func unarmed_blend(truefalse: bool):
	unarmed_blend_set = truefalse

func weapon_blend(truefalse: bool):
	weapon_blend_set = truefalse

func stun_blend(truefalse: bool):
	stun_blend_set = truefalse

func overheat_blend(truefalse: bool):
	overheat_blend_set = truefalse
	
func death_blend(truefalse: bool):
	death_blend_set = truefalse

func set_animation_speed(animation: String, speed: float):
	#set the speed in seconds.
	if animation == "firing":
		set("parameters/firing_timescale/scale", 1/speed)
	elif animation == "stow":
		set("parameters/stow_timescale/scale", 1/speed)
		print(1/speed)
	elif animation == "draw":
		set("parameters/draw_timescale/scale", 1/speed)
		print(1/speed)
	elif animation == "swing":
		set("parameters/swing_timescale/scale", 1/speed)
var current_anim_set: int = 0
var current_swing_anim: int = 0

func set_weapon_anim_set(set_num: int):
	current_anim_set = set_num
	set("parameters/idle_set/blend_position", set_num)
	set("parameters/walled_set/blend_position", set_num)
	set("parameters/swing_set/blend_position", Vector2(set_num, current_swing_anim))
	set("parameters/draw_set/blend_position", set_num)
	set("parameters/stow_set/blend_position", set_num)
	set("parameters/reload_set/blend_position", set_num)
	set("parameters/sprint_set/blend_position", set_num)
	set("parameters/firing_set/blend_position", set_num)
	set("parameters/throw_set/blend_position", set_num)
#func update_visuals():
	#model.rotation.y = lerp(model.rotation.y, desired_leg_angle, 0.5)

#parameters/BlendSpace1D/blend_position


func throw_speed(state_length: float):
	set("parameters/throw_scale/scale", 1/state_length)


func set_weapon_swing(set_num: int):
	current_swing_anim = set_num
	set("parameters/swing_set/blend_position", Vector2(current_anim_set, set_num))

func swing_weapon():
	set("parameters/weapon_swing/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func melee():
	pass
#CODE GRAVEYARD
#@onready var head_hitbox_loc = $"../Node/hip2/torso/head2/head_a/head"
#@onready var chest_hitbox_loc = $"../Node/hip2/torso/chest"
#@onready var crotch_hitbox_loc = $"../Node/hip2/crotch/hip"
#@onready var arm_l_hitbox_loc = $"../Node/hip2/torso/arm_l2/arm_l"
#@onready var arm_r_hitbox_loc = $"../Node/hip2/torso/arm_r2/arm_r"
#@onready var forearm_l_hitbox_loc = $"../Node/hip2/torso/arm_l2/forearm_l2/forearm_l"
#@onready var forearm_r_hitbox_loc = $"../Node/hip2/torso/arm_r2/forearm_r2/forearm_r"
#@onready var thigh_l_hitbox_loc = $"../Node/hip2/crotch/leg_l/thigh_l"
#@onready var thigh_r_hitbox_loc = $"../Node/hip2/crotch/leg_r/thigh_r"
#@onready var calf_l_hitbox_loc = $"../Node/hip2/crotch/leg_l/calf_l/calf_l_mesh"
#@onready var calf_r_hitbox_loc = $"../Node/hip2/crotch/leg_r/calf_r/calf_r_mesh"
#
#func create_hit_boxes():
	#pass
	##head 0.2 0.2 0.2
	#var head_hitbox = hitbox.new()
	#head_hitbox.name = "head_hitbox"
	#head_hitbox.create_collider(0.2, 0.2, 0.2)
	##head_hitbox.biped = biped
	#head_hitbox_loc.add_child(head_hitbox)
	##chest 0.2, 0.4, 0.2
	#var chest_hitbox = hitbox.new()
	#chest_hitbox.name = "chest_hitbox"
	#chest_hitbox.create_collider(0.2, 0.4, 0.2)
	#chest_hitbox_loc.add_child(chest_hitbox)
	##chest_hitbox_loc.biped = biped
	##crotch 0.2, 0.2, 0.2
	#var crotch_hitbox = hitbox.new()
	#crotch_hitbox.name = "crotch_hitbox"
	#crotch_hitbox.create_collider(0.2, 0.2, 0.2)
	#crotch_hitbox_loc.add_child(crotch_hitbox)
	##crotch_hitbox_loc.biped = biped
	##bicep 0.1, 0.3, 0.1
	#var arm_l_hitbox = hitbox.new()
	#arm_l_hitbox.name = "arm_l_hitbox"
	#arm_l_hitbox.create_collider(0.1, 0.3, 0.1)
	##arm_l_hitbox_loc.biped = biped
	#arm_l_hitbox_loc.add_child(arm_l_hitbox)
	#var arm_r_hitbox = hitbox.new()
	#arm_r_hitbox.name = "arm_r_hitbox"
	#arm_r_hitbox.create_collider(0.1, 0.3, 0.1)
	##arm_r_hitbox_loc.biped = biped
	#arm_r_hitbox_loc.add_child(arm_r_hitbox)
	##forearm 0.1, 0.3, 0.1
	#var forearm_l_hitbox = hitbox.new()
	#forearm_l_hitbox.name = "forearm_l_hitbox"
	#forearm_l_hitbox.create_collider(0.1, 0.3, 0.1)
	##forearm_l_hitbox_loc.biped = biped
	#forearm_l_hitbox_loc.add_child(forearm_l_hitbox)
	#var forearm_r_hitbox = hitbox.new()
	#forearm_r_hitbox.name = "forearm_r_hitbox"
	#forearm_r_hitbox.create_collider(0.1, 0.3, 0.1)
	##forearm_r_hitbox_loc.biped = biped
	#forearm_r_hitbox_loc.add_child(forearm_r_hitbox)
	##hand DO I DO HAND???
	##thigh 0.13, 0.5, 0.13
	#var thigh_l_hitbox = hitbox.new()
	#thigh_l_hitbox.name = "thigh_l_hitbox"
	#thigh_l_hitbox.create_collider(0.13, 0.5, 0.13)
	##thigh_l_hitbox_loc.biped = biped
	#thigh_l_hitbox_loc.add_child(thigh_l_hitbox)
	#var thigh_r_hitbox = hitbox.new()
	#thigh_r_hitbox.name = "thigh_r_hitbox"
	#thigh_r_hitbox.create_collider(0.13, 0.5, 0.13)
	##thigh_r_hitbox_loc.biped = biped
	#thigh_r_hitbox_loc.add_child(thigh_r_hitbox)
	##calf 0.13, 0.5, 0.13
	#var calf_l_hitbox = hitbox.new()
	#calf_l_hitbox.name = "calf_l_hitbox"
	#calf_l_hitbox.create_collider(0.13, 0.5, 0.13)
	##calf_l_hitbox_loc.biped = biped
	#calf_l_hitbox_loc.add_child(calf_l_hitbox)
	#var calf_r_hitbox = hitbox.new()
	#calf_r_hitbox.name = "calf_r_hitbox"
	#calf_r_hitbox.create_collider(0.13, 0.5, 0.13)
	##calf_r_hitbox.biped = biped
	#calf_r_hitbox_loc.add_child(calf_r_hitbox)
	##foot DO I DO FOOT?
