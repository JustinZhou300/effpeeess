extends torso_state
class_name torso_swing

var timer: float = 0
var firing_period #the inverse of rpm
var weapon #the weapon node
var has_fired_again: bool = 0
var swing_anim: int = 0

func enter():
	weapon = biped.inventory.equipped
	#resets back to first swing if the number of swings exceeded
	if swing_anim > weapon.swings_num - 1:
		swing_anim = 0
		print("reseting anim")
	biped.model_anim.set_weapon_swing(swing_anim)
	timer = 0 
	firing_period = (1 / float(weapon.firing_rpm)) * 60
	biped.model_anim.set_animation_speed("swing", firing_period)
	biped.model_anim.swing_weapon()
	has_fired_again = false
	
	
	#biped.model_anim.set_animation_speed("firing", 1 / firing_period)
	#weapon.fire()
	biped.stats.is_aiming = false

func exit():
	biped.stats.is_aiming = false
	

func update(delta):
	if Input.is_action_just_pressed("Primary_Fire"):
		has_fired_again = true
	
	timer += delta
	if timer >= firing_period:
		if biped.aim_wall_hit.is_colliding() or biped.arm_wall_hit.is_colliding():
			transition_to_state("torso_walled")
			swing_anim = 0
		elif biped.stats.is_sprinting:
			transition_to_state("torso_sprint")
			swing_anim = 0
		elif has_fired_again:
			transition_to_state("torso_swing")
			swing_anim += 1
			print("increase")
		else:
			transition_to_state("torso_idle")
			swing_anim = 0
		
	#Primary_Fire

func physics_update(delta):
	pass
