extends torso_state
class_name torso_unarmed_walled

func enter():
	pass
	#biped.model_anim.unarmed_blend(false)
	
func exit():
	pass
	#biped.model_anim.unarmed_blend(true)

func update(delta):
	if !biped.aim_wall_hit.is_colliding() and !biped.arm_wall_hit.is_colliding():
		transition_to_state("torso_unarmed")
	
	if Input.is_action_pressed("slot1") and biped.inventory.stow_slots[0] != null:
		biped.inventory.swap_position = 0
		transition_to_state("torso_draw")
	
	if Input.is_action_pressed("slot2") and biped.inventory.stow_slots[1] != null:
		biped.inventory.swap_position = 1
		transition_to_state("torso_draw")
		
	if Input.is_action_pressed("slot3") and biped.inventory.stow_slots[2] != null:
		biped.inventory.swap_position = 2
		transition_to_state("torso_draw")
	
func physics_update(delta):
	pass
