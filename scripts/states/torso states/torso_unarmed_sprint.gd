extends torso_state
class_name torso_unarmed_sprint

func enter():
	biped.model_anim.unarmed_blend(false)
	
func exit():
	biped.model_anim.unarmed_blend(true)

func update(delta):
	if !biped.stats.is_sprinting:
		transition_to_state("torso_unarmed")
		
	if Input.is_action_pressed("slot1") and biped.inventory.stow_slots[0] != null:
		biped.inventory.equipped = biped.inventory.stow_slots[0]
		biped.inventory.stow_slots[0] = null
		biped.stats.is_sprinting = false
		biped.inventory.swap_position = 0
		transition_to_state("torso_draw")
	
	if Input.is_action_pressed("slot2") and biped.inventory.stow_slots[1] != null:
		biped.inventory.equipped = biped.inventory.stow_slots[1]
		biped.inventory.stow_slots[1] = null
		biped.stats.is_sprinting = false
		biped.inventory.swap_position = 1
		transition_to_state("torso_draw")
		
	
	if Input.is_action_pressed("slot3") and biped.inventory.stow_slots[2] != null:
		biped.inventory.equipped = biped.inventory.stow_slots[2]
		biped.inventory.stow_slots[2] = null
		biped.stats.is_sprinting = false
		biped.inventory.swap_position = 2
		transition_to_state("torso_draw")
	
func physics_update(delta):
	pass
