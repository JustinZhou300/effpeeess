extends Node

enum element {kinetic, thermal, shock, holy}

var entity

var team

@export var entity_stat_sheet: stat_sheet


@export var hit_effect:PackedScene
@export var crit_effect:PackedScene
@export var shit_effect:PackedScene

#CREATURE/HUMAN/WHATEVER STATS

var buffs = []

#current values
var health_current
var mana_current
var poise_current
var exp_current

#defence
#resistance is % based between 0 and 1
#multiply that kind of damage by (1 - resistance)
#@export var physical_resistance = 0
#@export var thermal_resistance = 0
#@export var shock_resistance = 0
#@export var holy_resistance = 0
var resistance = []

#FINISH THIS USING ELEMENTAL ENUM + IMPLEMENT DAMAGE TYPE0

var level_current = 1
var level_max = 10

#independant stats
var strength = 0 #stat for str equipment, less weapon kickback
var endurance = 0 # increases health
var dexterity = 0 #stat for using dex equipment, faster weapon handling
var agility = 10 #affects speed
var intelligence = 0 #stat to use magic equipment
var mind = 0 #increases mana and exp gain factor
var luck = 0



#flags
var is_player: bool = false
var can_fire: bool
var can_jump: bool = true
var can_interact: bool = false
var is_grounded: bool
var was_grounded: bool #coyote grounded
var is_walled: bool
var was_walled: bool
var is_crouched: bool
var is_sprinting: bool
var is_sliding: bool
var is_stunned: bool
var is_KO: bool
var is_dead: bool
var is_unarmed: bool = true
var is_mantle: bool
var is_aiming: bool = false


#dependant stats
#movement
var SPEED_RUN: float #base speed
var SPEED_CROUCH: float# = SPEED_RUN * 0.5
var SPEED_SPRINT: float# = SPEED_RUN * 1.5
var SPEED_SLIDE: float# = SPEED_SPRINT
var TIMER_SLIDE: float  = 1 #how long will you slide (seconds)
var SPEED_ACCELERATION: float = 10
var SPEED_AIR: float# = 3
var SPEED_AIR_ACCELERATION: float# = 0.5 # OLD: 0.5 good low, 1 is good mid/high range.
var SPEED_MANTLE: float# = 2 #the rate you mantle upwards
var JUMP_FORCE: float #how hard you jump
#stats
var health_max = 100
var health_regen = 0
var mana_max = 100
var mana_regen = 5
var poise_max = 100
var poise_regen = 10
var exp_to_level
var exp_multiplier

var throw_force = 2

# targetting level - more level = more hud elements. at 0 there is no hud.
var targeting = 3



func stat_init():
	health_current = health_max
	mana_current = mana_max
	poise_current = poise_max
	exp_current = 0

func apply_stats(stat_sheet:Resource):
	strength = stat_sheet.strength #stat for str equipment, less weapon kickback
	endurance = stat_sheet.endurance # increases health
	dexterity = stat_sheet.dexterity #stat for using dex equipment, faster weapon handling
	agility = stat_sheet.agility #affects speed
	intelligence = stat_sheet.intelligence #stat to use magic equipment
	mind = stat_sheet.mind
	team = stat_sheet.team
	resistance = [stat_sheet.kinetic_resistance, stat_sheet.thermal_resistance, stat_sheet.shock_resistance, stat_sheet.holy_resistance]
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if hit_effect == null:
		hit_effect = load("res://effects/blood/blood_spatter.tscn")
	if crit_effect == null:
		crit_effect = load("res://effects/blood/blood_spatter.tscn")
	if shit_effect == null:
		shit_effect = load("res://effects/blood/blood_spatter.tscn")
	entity = get_parent()
	print("entity_stat_sheet: " + str(entity_stat_sheet))
	if entity_stat_sheet != null:
		apply_stats(entity_stat_sheet)
	update_stats()
	stat_init()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_stats(delta)
	impulse(delta)


func damage(damage:float, damage_type: element, knockback: float, position: Vector3, hitbox_type: int): #physical, fire, ice, shock, mana, stagger):
	print(str(damage) + str(" damage to ") + str(entity))
	if hitbox_type == 0:
		health_current -= damage * (1 - resistance[damage_type])
	elif hitbox_type == 1:
		health_current -= damage * (1 - resistance[damage_type]) * 2
	elif hitbox_type == 2:
		health_current -= damage * (1 - resistance[damage_type]) * 0.5
	else:
		push_error("there is an incorrect hitbox value")
	health_current = clamp(health_current, -100, health_max)
	if health_current <= 0 and health_current > -20:
		KO()
	elif health_current <= -20 and health_current != -100:
		die()
	elif health_current == -100:
		entity.queue_free()
	poise_current -= knockback
	if poise_current <= 0:
		is_stunned = true
	clamp(poise_current, 0, poise_max)
	
	
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
	if is_player:
		get_tree().quit()

func KO():
	is_KO = true

#this updates stats based on changes to attribute 
func update_stats():
	exp_to_level = 10 * (level_current)**2
	
	SPEED_RUN = 3.0 + agility * ((5.0-3.0) / 10.0)
	JUMP_FORCE = 3.0 + (agility * ((5.0-3.0)/10.0))
	SPEED_CROUCH = SPEED_RUN * 0.5
	SPEED_SPRINT = SPEED_RUN * 1.5
	SPEED_SLIDE = SPEED_SPRINT
	SPEED_ACCELERATION = 10.0
	SPEED_MANTLE = 2.0
	SPEED_AIR = 3.0
	SPEED_AIR_ACCELERATION = 0.5 + (agility * ((1-0.5)/10.0)) #0.5 # OLD: 0.5 good low, 1 is good mid/high range.
	health_max = 50.0 + (endurance * ((250.0-50.0)/10.0))
	poise_max = 50.0 + (endurance * ((200.0-50.0)/10.0))
	mana_max = 50.0 + (mind * ((250.0-50.0)/10.0))
	exp_multiplier = 1.0 + (mind * ((3.0-1.0)/10.0))

#this updates stats on a frame_by_frame basis
func process_stats(delta):
	if is_KO and health_current > 0:
		is_KO = false
	if is_dead and health_current > -20:
		is_dead = false
		is_KO = true
	if is_stunned and poise_current > 50:
		is_stunned = false
	#regen
	if !is_dead:
		health_current += delta * health_regen
		health_current = clamp(health_current, -100, health_max)
		mana_current += delta * mana_regen
		mana_current = clamp(mana_current, -100, mana_max)
		poise_current += delta * poise_regen
		poise_current = clamp(poise_current, -100, poise_max)
	

#function where you can modify a specific attribute
func modify_stat(stat_name: String, amount: int):
	if stat_name == "strength":
		strength += amount
	update_stats()

var jump_timer = 0
var jump_jumping_time = 0.01
var jump_jumping_bool: bool  = false
var jump_cooldown_time = 0.05
var jump_cooldown_bool: bool = false

func jump_handler(delta):
	
	if entity.jump_key_bool and entity.stats.can_jump and !jump_cooldown_bool:
		if Input.is_action_just_pressed("Jump"):
			if is_grounded or was_grounded:
				entity.velocity.y += entity.stats.JUMP_FORCE * delta / jump_jumping_time
				in_air_timer = 0
			elif is_walled or was_walled and !entity.check_mantle(): #and can_walljump
				if entity.velocity.y < entity.stats.JUMP_FORCE:
					#print(velocity.dot(wallHit.get_collision_normal()) / wallHit.get_collision_normal().length())
					entity.velocity -= (entity.velocity.dot(entity.wallHit.get_collision_normal()) / (entity.wallHit.get_collision_normal().length())) * entity.wallHit.get_collision_normal()
					entity.velocity.y = 0
					in_air_timer = 0
				#print(jump_force  * ((Vector3(0, 1, 0) + 0.5 * wallHit.get_collision_normal().normalized())) * delta / jump_jumping_time)
				entity.velocity +=  entity.stats.JUMP_FORCE  * ((Vector3(0, 1, 0) + 0.5 * entity.wallHit.get_collision_normal().normalized())) * delta / jump_jumping_time
				#print("aw yeah this shit is happening")
				entity.model_anim.jump_space_amount = 1
			if !jump_jumping_bool:
				jump_jumping_bool = true
			
	
	#THE JUMPING STATE BROTHERS (jumping, cooldown)
	if jump_jumping_bool:
		jump_timer += delta
		if jump_timer >= jump_jumping_time:
			jump_jumping_bool = false
			jump_cooldown_bool = true
			jump_timer = 0
	elif jump_cooldown_bool:
		jump_timer += delta
		if jump_timer >= jump_cooldown_time:
			jump_cooldown_bool = false
			jump_timer = 0
	
	#print("jump_jumping_bool: " + str(jump_jumping_bool))
	#print("jump_cooldown_bool: " + str(jump_cooldown_bool))


func interact():
	if can_interact:
		if entity.interact_ray.is_colliding():
			#print("looking at: " + str(interact_ray.get_collider()))
			if  Input.is_action_pressed("Interact"):
				entity.interact_ray.get_collider().interact(entity)
		
		if entity.inventory.equipped != null:
			if Input.is_action_pressed("DropWeapon"):
				entity.torso_handler.current_state.transition_to_state("torso_throw")
				

func set_collider(yesno: bool):
	#print("setting to: " + str(yesno))
	if is_player:
		entity.standing_col.disabled = !yesno
		entity.standing_col.disabled = !yesno
	else:
		entity.set_collision_layer_value(2, yesno)
		entity.set_collision_mask_value(2, yesno)

var in_air_timer = 0
var oldvel = Vector3(0, 0, 0)
func impulse(delta: float):
	if is_grounded and in_air_timer != 0:
		in_air_timer = 0
	else:
		in_air_timer += delta
	#print("oldvel.y: " + str(oldvel.y))
	#print("velocity.y: " + str(velocity.y))
	if oldvel.y < -10 and abs(oldvel.y - entity.velocity.y) > 10 and in_air_timer > 2:
		damage(abs(oldvel.y - entity.velocity.y),0 , 0, entity.global_position, 0)
	oldvel = entity.velocity
	#else:
		#if in_air_timer != 0:
			#in_air_timer = 0
