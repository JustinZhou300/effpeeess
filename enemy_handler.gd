extends CharacterBody3D
class_name enemy

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GRAVITY = 9.8

var SPEED_RUN: float = 2
var SPEED_ROTATE: float = 180

var patrols = []
var alerts = []
var targets = []
#var is_grounded: bool = false
var grounded_timer
var team = 1

var CURRENT_SPEED: float
var DESIRED_SPEED: float

var CURRENT_ROTATION: float
var DESIRED_ROTATION: float

var state_handler 
var collider
var model_anim
var view
var view_ray
var nav







@onready var stats = $stats
#
#func mantle_ray_manager():
	#

#var SPEED_RUN = 3.0
#var SPEED_SPRINT = SPEED_RUN * 1.5
#var SPEED_CROUCH = SPEED_RUN * 0.5
#var SPEED_SLIDE = SPEED_SPRINT
#var SPEED_AIRBOURNE = 5.0
#var SPEED_ACCELERATION = 10.0
#var SPEED_MANTLE = 2 #the rate you mantle upwards
#var SPEED_AIR = 3
#var SPEED_AIR_ACCELERATION = 0.5 # OLD: 0.5 good low, 1 is good mid/high range. 
#var TIMER_SLIDE = 1 #how long will you slide
#
#var jump_force = 3

var VELOCITY_FLAT
var VELOCITY
var VELOCITY_GRAVITY

#torso parameters
var playerSens = 0.002 #Sensitivity for the mouselook.
var direction = Vector3() #the direction the player is facing
var desired_lean: float = 0

##flags
#var is_player: bool = false
#var can_fire: bool
#var can_jump: bool = true
#var is_grounded: bool
#var was_grounded: bool #coyote grounded
#var is_stunned: bool = false
#var is_KO: bool = false
#var is_dead: bool = false
#var is_aiming: bool = false


func _ready() -> void:
	state_handler = $enemy_state
	model_anim = $model/AnimationTree
	view = $enemy_view
	view_ray = $view_ray
	nav = $nav 
	collider = $collider

func update_flags(delta):
	#grounded check
	if is_on_floor() and !stats.is_grounded:
		stats.is_grounded = true
		grounded_timer = 0
	elif !is_on_floor() and stats.is_grounded:
		stats.is_grounded = false
		grounded_timer = 0

func update_visuals():
	rotation.y = deg_to_rad(CURRENT_ROTATION)
	#if velocity == Vector3(0, 0, 0):
		#
	#else:
		

func _physics_process(delta: float) -> void:
	update_flags(delta)
	process_movement(delta)
	
	if !stats.is_grounded:
		velocity.y -= delta * GRAVITY
		#print(velocity)
	
	wallslidefix()
	move_and_slide()
	
	#if targets:
		#print("angle to target0 : " + str( angle_to_target ))

func _process(delta: float) -> void:
	update_visuals()
	
	

func update_rotation(delta):
	#print("current: " + str(CURRENT_ROTATION) + ", desired: " + str(DESIRED_ROTATION))
	if  DESIRED_ROTATION != CURRENT_ROTATION:
		var diff = DESIRED_ROTATION - CURRENT_ROTATION
		if diff < 0:
			diff += 360
		if diff > 180: #turn right
			CURRENT_ROTATION -= SPEED_ROTATE * delta
		else: #turn left
			CURRENT_ROTATION += SPEED_ROTATE * delta
		
		if CURRENT_ROTATION < -180:
			CURRENT_ROTATION += 360
		elif CURRENT_ROTATION > 180:
			CURRENT_ROTATION -= 360
		
		if abs(CURRENT_ROTATION - DESIRED_ROTATION) < SPEED_ROTATE * delta: 
			CURRENT_ROTATION = DESIRED_ROTATION

func update_speed(delta):
	#NO LONGER USED. UPDATE VELOCITY WITHIN
	if DESIRED_SPEED != CURRENT_SPEED:
		CURRENT_SPEED = lerp(CURRENT_SPEED, DESIRED_SPEED, 0.1)

func process_movement(delta):
	#update_speed(delta)
	update_rotation(delta)
	#velocity = lerp(velocity, (CURRENT_SPEED * Vector3(0, 0, -1).rotated(Vector3(0,1,0), deg_to_rad(CURRENT_ROTATION))), 0.1 )
	

func get_desired_angle(desired_position: Vector3):
	var desired_angle = fix_angle((-rad_to_deg(getDistAng(desired_position)[1]))-90)
	return desired_angle

func fix_angle(angle):
	if angle < -180:
		angle += 360
	elif angle > 180:
		angle -= 360
	return angle

var undesiredMotion = Vector3()
func wallslidefix():
	if self.is_on_wall():
		undesiredMotion = self.get_wall_normal() * (velocity.dot(self.get_wall_normal()));
		if rad_to_deg(acos(velocity.normalized().dot(self.get_wall_normal()))) > 90:
			velocity = velocity - undesiredMotion;

func getDistAng(targetPOS: Vector3):
	# gets the distance and the angle to the object from the current objects orientation
	# input: location of target
	# output: array of [DISTANCE, ANGLE]
	var dist = global_position.distance_to(targetPOS)
	var ang = Vector2(global_position.x, global_position.z).angle_to_point(Vector2(targetPOS.x, targetPOS.z))
	return [dist, ang]

var view_angle = 30

func check_view():
	if view.has_overlapping_bodies():
		for i in view.get_overlapping_bodies():
			var angle_to_target = rad_to_deg(Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), global_rotation.y).angle_to(global_position.direction_to(i.global_position)) )
			#print("angle_to_target" + str(angle_to_target))
			view_ray.look_at(i.global_position)
			#if view_ray.global_position.cross(Vector3.UP) == Vector3(0,0,0):
				#print("test")
			#print("view_ray.get_collider()" + str(view_ray.get_collider()))
			#print("i" + str((i)))
			if view_ray.is_colliding() and view_ray.get_collider() == i:
				if !targets.has(i) and i != self and angle_to_target < view_angle: #check if already in targets or is self
					if i.stats.team != stats.team: #check if same team
						print("appending: " + str(i))
						targets.append(i)

func add_patrol_point(point):
	if !patrols.has(point):
		patrols.append(point)

func remove_patrol_point(point):
	if point in patrols: #patrols.has(point):
		patrols.erase(point)

#======================
#TARGETTING FUNCTIONS
#======================

var current_target: CharacterBody3D = null
func manage_targetting():
	#set target if none
	if current_target == null and targets != []:
		current_target = targets[0]
	

#update depending on the scariness (dependant on level? stat total?)
func update_target():
	pass
