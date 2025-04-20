extends Node

enum element {kinetic, thermal, shock, holy}

var entity

var team

@export var hit_effect:PackedScene
@export var crit_effect:PackedScene
@export var shit_effect:PackedScene

#CREATURE/HUMAN/WHATEVER STATS

#stats
@export var health_max = 100
var health_regen = 0
var health_current

#defence
#resistence is % based between 0 and 1
#multiply that kind of damage by (1 - resistence)
@export var physical_resistence = 0
@export var thermal_resistence = 0
@export var shock_resistence = 0
@export var holy_resistence = 0
var resistence = []

#flags
#var can_fire: bool = false
#var is_aiming: bool = false
var is_dead: bool = false
var is_locked: bool = false
var is_powered: bool = false
var is_active: bool = false

func stat_init():
	health_current = health_max

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if hit_effect == null:
		hit_effect = load("res://effects/blood/spark.tscn")
	if crit_effect == null:
		crit_effect = load("res://effects/blood/spark.tscn")
	if shit_effect == null:
		shit_effect = load("res://effects/blood/spark.tscn")
	entity = get_parent()
	stat_init()
	
	resistence = [physical_resistence, thermal_resistence, shock_resistence, holy_resistence]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_stats(delta)


func damage(damage:float , damage_type: element, knockback: float, position: Vector3, hitbox_type: int, hit_dir:Vector3): #physical, fire, ice, shock, mana, stagger):
	print(str(damage) + str(" damage to ") + str(entity))
	health_current -= damage * (1 - resistence[damage_type])
	health_current = clamp(health_current, -100, health_max)
	if health_current <= 0:
		die()
	elif health_current == -100:
		entity.queue_free()
	
	
	#visual 
	if damage > 0:
		var damage_effect_instance
		if hitbox_type == 0:
			damage_effect_instance = hit_effect.instantiate()
		elif hitbox_type == 1:
			damage_effect_instance = crit_effect.instantiate()
		elif hitbox_type == 2:
			damage_effect_instance = shit_effect.instantiate()
		
		damage_effect_instance.global_position = position
		GAME.WORLD.PROJECTILES.add_child(damage_effect_instance)

func die():
	is_dead = true



#this updates stats on a frame_by_frame basis
func process_stats(delta):
	if is_dead and health_current > 0:
		is_dead = false
	#regen
	if !is_dead:
		health_current += delta * health_regen
		health_current = clamp(health_current, -100, health_max)
	
