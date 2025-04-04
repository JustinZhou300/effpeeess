extends torso_state
class_name torso_walled

func enter():
	biped.model_anim.set_walled(true)
	
func exit():
	biped.model_anim.set_walled(false)

func update(delta):
	if !biped.aim_wall_hit.is_colliding() and !biped.arm_wall_hit.is_colliding():
		transition_to_state("torso_idle")
	
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
