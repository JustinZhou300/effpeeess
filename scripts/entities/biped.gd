extends CharacterBody3D

var team = 0

#node definitions
@onready var playerView = $playerView
@onready var playerViewCamera = $playerView/playerViewCamera
@onready var playerViewRay = $playerView/playerViewRay
@onready var standingCollider = $stand_col
@onready var crouchingCollider = $crouch_col
@onready var model = $playerView/blockbench_export
@onready var model_anim = $playerView/blockbench_export/AnimationTree
var model_fp
var model_anim_fp
#@onready var model_anim_fp = $playerView/playerViewCamera/blockbench_export/AnimationTree
@onready var inventory = $inventory
@onready var stats = $stats
#@onready var pixelFilter = $playerView/pixel_filter

#state machines
@onready var torso_handler = $torso_state
@onready var leg_handler = $leg_state

#ray cast definitions
@onready var groundCast =  $ground_cast
@onready var headBonk = $head_bonk
@onready var wallHit = $wall_hit
@onready var aim_wall_hit = $playerView/playerViewCamera/aim_wall_hit
@onready var arm_wall_hit = $playerView/playerViewCamera/arm_wall_hit
@onready var lean_cast_right = $playerView/lean_cast_right
@onready var lean_cast_left = $playerView/lean_cast_left

@onready var interact_ray = $playerView/playerViewCamera/interact_ray
@onready var aim_ray = $playerView/playerViewRay/aim_ray
@onready var shoot_ray = $playerView/playerViewCamera/shoot_ray

@onready var mantle_ray = $playerView/mantle_rays/mantle_ray
@onready var mantle_ray_r = $playerView/mantle_rays/mantle_ray_r
@onready var mantle_ray_l = $playerView/mantle_rays/mantle_ray_l
@onready var mantle_ray_alt = $playerView/mantle_rays/mantle_ray_alt
@onready var mantle_ray_r_alt = $playerView/mantle_rays/mantle_ray_r_alt
@onready var mantle_ray_l_alt = $playerView/mantle_rays/mantle_ray_l_alt

#
#func mantle_ray_manager():
	#

var GRAVITY = 9.8



var VELOCITY_FLAT
var VELOCITY
var VELOCITY_GRAVITY

#torso parameters
var playerSens = 0.002 #Sensitivity for the mouselook.
var direction = Vector3() #the direction the player is facing
var desired_lean: float = 0
var viewbounds = [ 75.0, 75.0 ]


var input_dir
var look_input_dir

#body location nodes
var gun_loc
var stow_0
var stow_1
var stow_2


##======================================
## Head bob & FOV Settings
##======================================
#var headBobFlag = true
##Head bob values
#const bobFreq = 2.0
#const bobAmp = 0.08
#var tbob = 0.0
#FOV
const fovBase = 90.0
const fovChange = 1.5



var coyote_time = 0.1 #coyote leeway in seconds
var grounded_timer = 0
var walled_timer = 0



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#add_to_group("PLAYERS")
	gun_loc = model_anim.gun_loc
	stow_0 = model_anim.stow0_loc
	stow_1 = model_anim.stow1_loc
	stow_2 = model_anim.stow2_loc
	
	#makes the hitboxes on the player excepted from shooting rays.
	for i in model_anim.hitbox_locs:
		aim_ray.add_exception(i.get_child(0, false))
		shoot_ray.add_exception(i.get_child(0, false))
	for i in model_anim.critbox_locs:
		aim_ray.add_exception(i.get_child(0, false))
		shoot_ray.add_exception(i.get_child(0, false))
	for i in model_anim.shitbox_locs:
		aim_ray.add_exception(i.get_child(0, false))
		shoot_ray.add_exception(i.get_child(0, false))
	
	#add_exception(node: CollisionObject3D)
	stats.is_player = true
	
var y_val = 0
var x_val = 0

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		#playerView.rotate_y(-event.relative.x * playerSens)
		y_val += -event.relative.x * playerSens
		if y_val > 180:
			y_val -= 180
		elif y_val < -180:
			y_val += 180
		#playerViewCamera.rotate_x(-event.relative.y * playerSens)
		x_val += -event.relative.y * playerSens
		#playerViewCamera.rotation.x = clamp(playerViewCamera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
		x_val = clamp(x_val, deg_to_rad(-viewbounds[0]), deg_to_rad(viewbounds[1]))
		
		playerView.rotation.y = y_val
		playerViewRay.rotation.x = x_val
		#playerViewCamera.rotation.x = x_val
	
	#input_dir = Input.get_vector("LookLeft", "LookRight", "LookUp", "LookDown")
	#playerView.rotate_y(input_dir.x * playerSens)
	#playerViewCamera.rotate_x(input_dir.y * playerSens)
	#playerViewCamera.rotation.x = clamp(playerViewCamera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		#

var oldvel = Vector3(0, 0, 0)

func _physics_process(delta: float) -> void:
	
	process_input(delta)
	stats.interact()
	update_flags(delta)
	stats.jump_handler(delta)
	if !stats.is_grounded:
		velocity.y -= delta * GRAVITY
	wallslidefix()
	move_and_slide()
	aim_handler(delta)
	
	

#var in_air_timer: float = 0

func _process(delta: float) -> void:
	process_visuals(delta)
	#print(FOV_modifier)



var jump_key_bool: bool = false #whether jump is held
func process_input(delta):
	input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	look_input_dir = Input.get_vector("LookLeft", "LookRight", "LookUp", "LookDown")#look_input_dir = Input.get_vector("LookLeft", "LookRight", "LookUp", "LookDown")
	y_val -= look_input_dir.x * 0.1
	x_val -= look_input_dir.y * 0.05
	x_val = clamp(x_val, deg_to_rad(-75), deg_to_rad(75))
	playerView.rotation.y = y_val
	playerViewRay.rotation.x = x_val
	#playerViewCamera.rotation.x = x_val
	
	
	direction = (playerView.transform.basis * Vector3(input_dir.x, 0, input_dir.y))#.normalized()
	
	#handle jump input
	if  Input.is_action_pressed("Jump"):
		jump_key_bool = true
	else:
		jump_key_bool = false
	
	if Input.is_action_pressed("LeanLeft") and Input.is_action_pressed("LeanRight"):
		desired_lean = 0
	elif Input.is_action_pressed("LeanLeft") and !lean_cast_left.is_colliding():
		desired_lean = 1
	elif Input.is_action_pressed("LeanRight") and !lean_cast_right.is_colliding():
		desired_lean = -1
	else:
		desired_lean = 0
	
	
	
	




var FOV_modifier: int #lets you modify the amount hte FOV is
func process_visuals(delta):
	
	#scale_filter()
	
	if inventory.equipped != null:
		inventory.equipped.global_position = gun_loc.global_position
		if stats.is_aiming and shoot_ray.is_colliding():
			inventory.equipped.look_at(shoot_ray.get_collision_point())
		else:
			inventory.equipped.global_rotation = gun_loc.global_rotation
	if inventory.stow_slots[0] != null:
		inventory.stow_slots[0].global_position = stow_0.global_position
		inventory.stow_slots[0].global_rotation = stow_0.global_rotation
	if inventory.stow_slots[1] != null:
		inventory.stow_slots[1].global_position = stow_1.global_position
		inventory.stow_slots[1].global_rotation = stow_1.global_rotation
	if inventory.stow_slots[2] != null:
		inventory.stow_slots[2].global_position = stow_2.global_position
		inventory.stow_slots[2].global_rotation = stow_2.global_rotation
	
	
	#if headBobFlag == true and !is_sliding: # and !isPlayerSliding
		#tbob += delta * velocity.length() * float(is_on_floor())
		#playerViewCamera.transform.origin = _headbob(tbob)
	#var target_fov = fovBase + fovChange + FOV_modifier# * velocity_clamped
	var target_fov = fovBase + fovChange + FOV_modifier# * velocity_clamped
	playerViewCamera.fov = lerp(playerViewCamera.fov, target_fov, delta * 8.0)
	
	playerViewCamera.global_position = lerp(playerViewCamera.global_position, model_anim.head_pos.global_position, 0.5)
	playerViewRay.rotation.z = model_anim.head_pos.global_rotation.z/3
	
	#print(model_anim.head_pos.global_position)
	
	
	





func update_flags(delta):
	#grounded check
	if is_on_floor() and !stats.is_grounded:
		stats.is_grounded = true
		grounded_timer = 0
	elif !is_on_floor() and stats.is_grounded:
		stats.is_grounded = false
		grounded_timer = 0
	
	#walltouch_check
	#if is_on_wall_only() and !is_walled:
		#is_walled = true
		#walled_timer = 0
	#elif !is_on_wall_only() and is_walled:
		#is_walled = false
		#walled_timer = 0
	
	wallHit.target_position = 0.7 * direction
	
	if wallHit.is_colliding():
		stats.is_walled = true
		walled_timer = 0
	else:
		stats.is_walled = false
		walled_timer = 0
	
	#coyote calcs
	grounded_timer += delta
	if stats.was_grounded != stats.is_grounded and grounded_timer >= coyote_time:
		stats.was_grounded = !stats.was_grounded
	
	walled_timer += delta
	if stats.was_walled != stats.is_walled and walled_timer >= coyote_time:
		stats.was_walled = !stats.was_walled
	
	
	
	#print("is_walled: " + str(is_walled))
	#print("was_walled: " + str(was_walled))
	#print("is_grounded: " + str(is_grounded))
	#print("was_grounded: " + str(was_grounded))
	#print("walled_timer: " + str(walled_timer))
	#print("grounded_timer: " + str(grounded_timer))

func toggle_crouch(CrouchBool: bool):
	if CrouchBool:
		stats.is_crouched = true
		mantle_ray.enabled = false
		mantle_ray_r.enabled = false
		mantle_ray_l.enabled = false
		standingCollider.disabled = true
		crouchingCollider.disabled = false
		if is_on_floor():
			position -= Vector3(0, 0.3, 0)
			if inventory.equipped != null: inventory.equipped.global_position -= Vector3(0, 0.3, 0)
			if inventory.stow_slots[0] != null: inventory.stow_slots[0].global_position -= Vector3(0, 0.3, 0)
			if inventory.stow_slots[1] != null: inventory.stow_slots[1].global_position -= Vector3(0, 0.3, 0)
			if inventory.stow_slots[2] != null: inventory.stow_slots[2].global_position -= Vector3(0, 0.3, 0)
		
	else:
		stats.is_crouched = false
		mantle_ray.enabled = true
		mantle_ray_r.enabled = true
		mantle_ray_l.enabled = true
		standingCollider.disabled = false
		crouchingCollider.disabled = true
		if is_on_floor():
			position += Vector3(0, 0.3, 0)

var undesiredMotion = Vector3()
func wallslidefix():
	if self.is_on_wall():
		undesiredMotion = self.get_wall_normal() * (velocity.dot(self.get_wall_normal()));
		if rad_to_deg(acos(velocity.normalized().dot(self.get_wall_normal()))) > 90:
			velocity = velocity - undesiredMotion;

var aim_restore_val: float = 0.05

func aim_handler(delta):
	#OLD AND BUSTED
	#playerViewCamera.global_rotation = lerp(playerViewCamera.global_rotation, playerViewRay.global_rotation - (aim_ray.rotation - shoot_ray.rotation), 0.5) 
	
	#NEW HOTNESS
	playerViewCamera.global_rotation.x = lerp_angle(playerViewCamera.global_rotation.x, playerViewRay.global_rotation.x - (aim_ray.rotation.x - shoot_ray.rotation.x), 0.5)
	playerViewCamera.global_rotation.y = lerp_angle(playerViewCamera.global_rotation.y, playerViewRay.global_rotation.y - (aim_ray.rotation.y - shoot_ray.rotation.y), 0.5)
	playerViewCamera.global_rotation.z = lerp_angle(playerViewCamera.global_rotation.z, playerViewRay.global_rotation.z - (aim_ray.rotation.z - shoot_ray.rotation.z), 0.5)
	
	#shoot_ray.rotation = lerp(shoot_ray.rotation, aim_ray.rotation, 0.05)
	shoot_ray.rotation.x = lerp_angle(shoot_ray.rotation.x, aim_ray.rotation.x, aim_restore_val)
	shoot_ray.rotation.y = lerp_angle(shoot_ray.rotation.y, aim_ray.rotation.y, aim_restore_val)
	shoot_ray.rotation.z = lerp_angle(shoot_ray.rotation.z, aim_ray.rotation.z, aim_restore_val)

func check_mantle():
	#checks if you can mantle. alt rays are for checking back faces so you can't climb walls when
	#it's segmented. 
	
	if mantle_ray.is_colliding() and mantle_ray_alt.is_colliding() and mantle_ray.get_collider_shape() == mantle_ray_alt.get_collider_shape():#mantle_ray.get_collision_normal() == Vector3(0, 1, 0):
		if rad_to_deg(mantle_ray.get_collision_normal().angle_to(Vector3(0, 1, 0))) <= 50:
			return true
		else: return false
	elif mantle_ray_l.is_colliding() and mantle_ray_l_alt.is_colliding() and mantle_ray_l.get_collider_shape() == mantle_ray_l_alt.get_collider_shape():
		if rad_to_deg(mantle_ray_l.get_collision_normal().angle_to(Vector3(0, 1, 0))) <= 50:
			return true
		else: return false
	elif mantle_ray_r.is_colliding() and mantle_ray_r_alt.is_colliding() and mantle_ray_r.get_collider_shape() == mantle_ray_r_alt.get_collider_shape():
		if rad_to_deg(mantle_ray_r.get_collision_normal().angle_to(Vector3(0, 1, 0))) <= 50:
			return true
		else: return false
	else:
		return false




#code graveyard

#
#func _headbob(time) -> Vector3:
	##This function just gives a headbob to the character.
	#var pos = Vector3.ZERO
	#pos.y = sin(time * bobFreq) * bobAmp
	#return pos


#func scale_filter():
	## 1920 = 16, 1080 = 9
	#var resolution = DisplayServer.window_get_size()
	#print('resolution = ' + str(Vector2( ( (resolution[0] * 16)/1920), ( (resolution[1]* 9 )/ 1080) )))
	#pixelFilter.scale = Vector2( ( (resolution[0] * 16)/1920), ( (resolution[1]* 9 )/ 1080) )
