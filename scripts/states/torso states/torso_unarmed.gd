extends torso_state
class_name torso_unarmed



func enter():
	biped.model_anim.unarmed_blend(true)
	biped.model_anim.weapon_blend(false)
	biped.stats.can_interact = true
	biped.model_anim.set_hands("fist")

func exit():
	biped.stats.can_interact = false

func update(delta):
	if Input.is_action_just_pressed("Primary_Fire"):
		transition_to_state("torso_punch")
	
	if biped.stats.is_mantle:
		transition_to_state("torso_mantle")
	
	#if biped.aim_wall_hit.is_colliding() or biped.arm_wall_hit.is_colliding():
		#transition_to_state("torso_unarmed_walled")
	
	if biped.stats.is_sprinting:
		transition_to_state("torso_unarmed_sprint")
	
	if biped.inventory.equipped != null:
		transition_to_state("torso_draw")
	
	if Input.is_action_pressed("slot1") and biped.inventory.stow_slots[0] != null:
		biped.inventory.equipped = biped.inventory.stow_slots[0]
		biped.inventory.stow_slots[0] = null
		biped.inventory.swap_position = 0
		transition_to_state("torso_draw")
		
	if Input.is_action_pressed("slot2") and biped.inventory.stow_slots[1] != null:
		biped.inventory.equipped = biped.inventory.stow_slots[1]
		biped.inventory.stow_slots[1] = null
		biped.inventory.swap_position = 1
		transition_to_state("torso_draw")
	
	if Input.is_action_pressed("slot3") and biped.inventory.stow_slots[2] != null:
		biped.inventory.equipped = biped.inventory.stow_slots[2]
		biped.inventory.stow_slots[2] = null
		biped.inventory.swap_position = 2
		transition_to_state("torso_draw")

func physics_update(delta):
	pass
