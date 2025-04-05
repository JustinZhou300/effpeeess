extends torso_state
class_name torso_idle

func enter():
	biped.stats.can_interact = true
	biped.stats.is_aiming = true
	biped.model_anim.set_weapon_anim_set(biped.inventory.equipped.animation_set)
	biped.model_anim.set_hands("hold")
	#biped.model_anim.unarmed_blend(false)
	#biped.model_anim.weapon_blend(true)
	
func exit():
	biped.stats.can_interact = false
	biped.stats.is_aiming = false

func update(delta):
	#if Input.is_action_just_pressed("Primary_Fire"):
		#transition_to_state("torso_firing")
	
	if Input.is_action_just_pressed("Primary_Fire"):
		biped.inventory.equipped.primary_fire()
	if Input.is_action_just_pressed("Secondary_Fire"):
		biped.inventory.equipped.secondary_fire()
	
	if biped.aim_wall_hit.is_colliding() or biped.arm_wall_hit.is_colliding():
		if !biped.inventory.equipped.is_melee:
			transition_to_state("torso_walled")
	
	if Input.is_action_just_pressed("Reload"):
		biped.inventory.equipped.proc_reload()
	
	if biped.stats.is_sprinting:
		transition_to_state("torso_sprint")
	
	if biped.inventory.equipped == null:
		transition_to_state("torso_unarmed")
	
	#biped.inventory.weapon_switch_handler()
	if Input.is_action_pressed("slot1"):
		biped.inventory.swap_position = 0
		transition_to_state("torso_stow")
	
	if Input.is_action_pressed("slot2"):
		biped.inventory.swap_position = 1
		transition_to_state("torso_stow")
		
	if Input.is_action_pressed("slot3"):
		biped.inventory.swap_position = 2
		transition_to_state("torso_stow")

func physics_update(delta):
	pass
