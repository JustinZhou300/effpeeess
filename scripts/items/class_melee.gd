extends "res://scripts/items/class_item.gd"
class_name weapon_melee

enum animation_sets {one_handed2, two_handed, one_handed, flashlight_handed, melee}

enum element {kinetic, thermal, shock, holy}

@export_subgroup("Weapon Parameters")
@export var animation_set: animation_sets = 4
@export var damage: int = 0
@export var elemental_type: element = 0
@export var melee_damage: int = 20
@export var melee_elemental_type: element = 0
@export var melee_stagger_damage: int = 0
#@export var firing_rpm: int = 200
@export var melee_rpm: int = 200
@export var stagger_damage: int = 0
@export var has_animations = false
@export var swings_num = 3
@export var tracer_colour: Color


@export var damage_ray: RayCast3D

#weapon variables
var current_ammo = 0

#Stability

@export var stow_speed: float = 0.5 #how long to stow weapon in seconds
@export var draw_speed: float = 0.5 #how long to draw weapon in seconds

#var muzzle_light
#var muzzle_flash
#var tracer
#var flash
var ricochet
var bullet_hole

func weapon_ready():
	is_weapon = true
	is_melee = true
	#tracer = preload("res://tracer.tscn")
	#flash = preload("res://flash.tscn")
	ricochet = preload("res://ricochet.tscn")
	bullet_hole = preload("res://bullet_hole.tscn")
	#muzzle_light = $muzzle_light
	#muzzle_flash = $muzzle_flash

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_item_ready()
	weapon_ready()
	 # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func throw_hit():
	item_ray.get_collider().entity.stats.damage(damage, 0, linear_velocity.length() * mass, global_position, item_ray.get_collider().hitbox_type, linear_velocity)
	linear_velocity = -linear_velocity/3
	print("hitbox: " + str(item_ray.get_collider()) + ", entity: " + str(item_ray.get_collider().entity))

func _process(delta: float) -> void:
	pass


func primary_fire():
	biped.torso_handler.current_state.transition_to_state("torso_swing")
	
	

func swing():
	if biped.torso_handler.current_state.name != "torso_swing":
		biped.torso_handler.current_state.swing_anim = 0
	else:
		biped.torso_handler.current_state.swing_anim += 1

func secondary_fire():
	pass


func hit():
	pass

func proc_reload():
	pass
