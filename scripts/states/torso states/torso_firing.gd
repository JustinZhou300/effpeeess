extends torso_state
class_name torso_firing

var timer: float = 0
var firing_period #the inverse of rpm
var weapon #the weapon node
var has_fired_again: bool = 0
var has_primary_fired_again: bool = 0
var has_secondary_fired_again: bool = 0



var burst_timer: float = 0

func enter():
	timer = 0 
	biped.model_anim.fire_weapon()
	has_fired_again = false
	has_primary_fired_again = false
	has_secondary_fired_again = false
	
	weapon = biped.inventory.equipped
	firing_period = (1 / float(weapon.firing_rpm)) * 60
	biped.model_anim.set_animation_speed("firing", firing_period)
	weapon.fire()
	biped.stats.is_aiming = true
	burst_timer = 0
	
	if biped.inventory.equipped.has_animations:
		biped.inventory.equipped.model_anim.set_animation_speed("firing", firing_period)
		biped.inventory.equipped.model_anim.fire()

func exit():
	biped.stats.is_aiming = false
	

func update(delta):
	if biped.inventory.equipped.burst_counter > 0:
		burst_timer += delta
		if burst_timer > biped.inventory.equipped.burst_time:
			biped.inventory.equipped.burst_counter -= 1
			transition_to_state("torso_firing")
		
	else:
		if Input.is_action_just_pressed("Primary_Fire"):
			has_primary_fired_again = true
		elif Input.is_action_just_pressed("Secondary_Fire"):
			has_secondary_fired_again = true
		
		timer += delta
		if timer >= firing_period:
			if biped.aim_wall_hit.is_colliding() or biped.arm_wall_hit.is_colliding():
				transition_to_state("torso_walled")
			elif biped.stats.is_sprinting:
				transition_to_state("torso_sprint")
			elif has_primary_fired_again:# and biped.inventory.equipped.current_ammo > 0:
				biped.inventory.equipped.primary_fire()
			elif has_secondary_fired_again:
				biped.inventory.equipped.secondary_fire()
			elif biped.inventory.equipped.is_automatic and Input.is_action_pressed("Primary_Fire")and biped.inventory.equipped.current_ammo > 0:
				transition_to_state("torso_firing")
			else:
				transition_to_state("torso_idle")
			
		#Primary_Fire

func physics_update(delta):
	pass
