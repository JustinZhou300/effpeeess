extends torso_state
class_name torso_swing

var timer: float = 0
var firing_period #the inverse of rpm
var weapon #the weapon node
var swing_anim: int = 0

var has_primary_fired_again
var has_secondary_fired_again

var has_hit: Array[Node3D]

func enter():
	#set weapon
	weapon = biped.inventory.equipped
	#resets back to first swing if the number of swings exceeded
	if swing_anim > weapon.swings_num - 1:
		swing_anim = 0
		print("reseting anim")
	biped.model_anim.set_weapon_swing(swing_anim)
	timer = 0 
	firing_period = (1 / float(weapon.melee_rpm)) * 60
	biped.model_anim.set_animation_speed("swing", firing_period)
	biped.model_anim.swing_weapon()
	
	has_primary_fired_again = false
	has_secondary_fired_again = false
	biped.stats.is_aiming = false
	weapon.damage_ray.enabled = true
	has_hit = [biped]

func exit():
	biped.stats.is_aiming = false
	weapon.damage_ray.enabled = false
	

func update(delta):
	if Input.is_action_just_pressed("Primary_Fire"):
		has_primary_fired_again = true
	if Input.is_action_just_pressed("Secondary_Fire"):
		has_secondary_fired_again = true
	
	
	
	timer += delta
	if timer >= firing_period:
		if biped.stats.is_sprinting:
			transition_to_state("torso_sprint")
			swing_anim = 0
		elif has_primary_fired_again:# and biped.inventory.equipped.current_ammo > 0:
				biped.inventory.equipped.primary_fire()
		elif has_secondary_fired_again:
				biped.inventory.equipped.secondary_fire()
		#elif has_fired_again:
			#transition_to_state("torso_swing")
			#swing_anim += 1
			#print("increase")
		else:
			transition_to_state("torso_idle")
			swing_anim = 0
		
	#Primary_Fire

func physics_update(delta):
	print(weapon.damage_ray.get_collider())
	if weapon.damage_ray.is_colliding():
		if weapon.damage_ray.get_collider().get_collision_layer() == 1:
			print("clink")
		elif weapon.damage_ray.get_collider().get_collision_layer() == 8:
			if weapon.damage_ray.get_collider().entity not in has_hit:
				#print("damage to: " + str(weapon.damage_ray.get_collider().entity))
				weapon.damage_ray.get_collider().entity.stats.damage(weapon.melee_damage, weapon.melee_elemental_type, weapon.melee_stagger_damage, weapon.damage_ray.get_collision_point(), weapon.damage_ray.get_collider().hitbox_type, Vector3(0, 0, -1).rotated(Vector3.UP, biped.playerView.rotation.y).rotated(Vector3(1, 0, 0), biped.playerView.rotation.x))
				has_hit.append(weapon.damage_ray.get_collider().entity)
				
				
