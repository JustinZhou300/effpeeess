extends "res://scripts/items/class_item.gd"
class_name weapon_gun

#one handed (two hands), two handed (rifle), one handed (one hand) ( revolver), (flashlight)
enum animation_sets {one_handed2, two_handed, one_handed, flashlight_handed, melee}

@export_subgroup("Weapon Parameters")
@export var animation_set: animation_sets = 0
@export var damage: int = 0
@export var stagger_damage: int = 0
@export var firing_rpm: int = 200
@export var is_automatic: bool = false
@export var burst_amount: int = 1 #the amount fired per trigger pull.
@export var magazine_size: int = 8 #how many bullets in a magazine
@export var ammo_name: String = "bullets" #the name of the ammo type, will check inventory for it.
@export var is_projectile: bool
@export var tracer_colour: Color
@export var firing_location: Node3D
@export var swings_num = 1
var current_firing_location:Node3D
#weapon variables
var current_ammo = 0

#independant variables
#var damage
var balance #analogous to stability
var weight #analogous to handling


#dependant variables
@export var recoil_amount: int #the amount of recoil (stablity)
@export var stow_speed: float = 0.5 #how long to stow weapon in seconds
@export var draw_speed: float = 0.5 #how long to draw weapon in seconds
@export var reload_speed: float = 1 #how long to reload weapon in seconds

func update_stats():
	pass

@export var has_animations = false
var model_anim
@export var tracer: PackedScene
@export var flash: PackedScene
@export var ricochet: PackedScene
@export var bullet_hole: PackedScene
@export var sound: PackedScene
@export var projectile: PackedScene

func weapon_ready():
	if has_animations:
		model_anim = $model/AnimationTree
	is_weapon = true
	current_ammo = magazine_size
	if tracer == null:
		tracer = preload("res://tracer.tscn")
	if flash == null:
		flash = preload("res://flash.tscn")
	if ricochet == null:
		ricochet = preload("res://ricochet.tscn")
	if bullet_hole == null:
		bullet_hole = preload("res://bullet_hole.tscn")
	if sound == null:
		sound = preload("res://sound.tscn")
	if projectile == null and is_projectile:
		projectile = preload("res://projectile.tscn")

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_gun = true
	base_item_ready()
	weapon_ready()

func _process(delta: float) -> void:
	pass
	#process_muzzle_flash(delta)
	#print(tracer_list)

var muzzle_flash_timer = 0.05
var muzzle_flash_timer_max = 0.05


func shoot_muzzle_flash():
	var flash_instance = flash.instantiate()
	flash_instance.firing_pos = current_firing_location.global_position
	current_firing_location.add_child(flash_instance)
	#item.state_handler.current_state.weapon_model

func create_sound():
	var sound_instance = sound.instantiate()
	sound_instance.set_position = current_firing_location.global_position
	GAME.WORLD.SOUNDS.add_child(sound_instance)

func shoot_hitscan():
	create_sound()
	shoot_muzzle_flash()
	if biped.shoot_ray.is_colliding():
		print(biped.shoot_ray.get_collider())
		var tracer_instance = tracer.instantiate()
		tracer_instance.firing_pos = current_firing_location.global_position
		#tracer_instance.firing_rot = biped.playerViewRay.global_rotation
		tracer_instance.hit_pos = biped.shoot_ray.get_collision_point()
		tracer_instance.dist = current_firing_location.global_position.distance_to(biped.shoot_ray.get_collision_point())
		GAME.WORLD.PROJECTILES.add_child(tracer_instance)
		print(biped.shoot_ray.get_collision_mask_value(1))
		
		#spawn ricochet
		#currently has issue - need code inside ricochet to place it somewhere and
		#make it self decay thru script
		if biped.shoot_ray.get_collider().get_collision_layer() == 1:
			var ricochet_instance = ricochet.instantiate()
			ricochet_instance.spawn_position = biped.shoot_ray.get_collision_point()
			ricochet_instance.wall_normal = biped.shoot_ray.get_collision_normal()
			var bullet_hole_instance = bullet_hole.instantiate()
			bullet_hole_instance.spawn_position = biped.shoot_ray.get_collision_point()
			bullet_hole_instance.wall_normal = biped.shoot_ray.get_collision_normal()
			GAME.WORLD.PROJECTILES.add_child(ricochet_instance)
			GAME.WORLD.PROJECTILES.add_child(bullet_hole_instance)
			print("biped.shoot_ray.get_collider():" + str(biped.shoot_ray.get_collider()))
			print("biped.shoot_ray.get_collision_mask_value(1)" + str(biped.shoot_ray.get_collider().get_collision_layer()))
		elif biped.shoot_ray.get_collider().get_collision_layer() == 8:
			print("hit_entity")
			print(biped.shoot_ray.get_collider())
			print(biped.shoot_ray.get_collider().entity.stats)
			biped.shoot_ray.get_collider().entity.stats.damage(damage, stagger_damage, biped.shoot_ray.get_collision_point(), biped.shoot_ray.get_collider().hitbox_type)
			#biped.shoot_ray.get_collider().
			#PUT FUNCTION IN STATS FOR THE TYPE OF BLOOD

func shoot_projectile():
	create_sound()
	shoot_muzzle_flash()
	var projectile_instance = projectile.instantiate()
	projectile_instance.initial_position = current_firing_location
	projectile_instance.direction = Vector3(0, 0, -1).rotated(Vector3(1, 0, 0), biped.x_val).rotated(Vector3(0, 1, 0), biped.y_val)
	GAME.WORLD.PROJECTILES.add_child(projectile_instance)
	

#DELET THIS
#playerView.rotation.y = y_val
#playerViewRay.rotation.x = x_val

func primary_fire():
	if current_ammo > 0:
		biped.torso_handler.current_state.transition_to_state("torso_firing")
	else:
		biped.torso_handler.current_state.transition_to_state("torso_reload")
	

func secondary_fire():
	biped.torso_handler.current_state.transition_to_state("torso_swing")

func fire():
	shoot_hitscan()
	gun_kickback(100)
	current_ammo -= 1
	#weapon kickback
	
	
	#biped.shoot_ray.rotation.x += 0.1
	#biped.shoot_ray.rotation.y += randi_range(-2, 2) * 0.01

func gun_kickback(amount: int):
	biped.shoot_ray.rotation.x += 0.1
	biped.shoot_ray.rotation.y += randi_range(-2, 2) * 0.01

func proc_reload():
	if current_ammo < magazine_size:
		biped.torso_handler.current_state.transition_to_state("torso_reload")

func reload():
	current_ammo = magazine_size
