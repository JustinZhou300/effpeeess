extends torso_state
class_name torso_sprint

func enter():
	biped.model_anim.set_sprint(true)
	
func exit():
	biped.model_anim.set_sprint(false)

func update(delta):
	if !biped.stats.is_sprinting:
		transition_to_state("torso_idle")
	
	if Input.is_action_pressed("slot1"):
		biped.stats.is_sprinting = false
		biped.inventory.swap_position = 0
		transition_to_state("torso_stow")
	
	if Input.is_action_pressed("slot2"):
		biped.stats.is_sprinting = false
		biped.inventory.swap_position = 1
		transition_to_state("torso_stow")
		
	
	if Input.is_action_pressed("slot3"):
		biped.stats.is_sprinting = false
		biped.inventory.swap_position = 2
		transition_to_state("torso_stow")
	
func physics_update(delta):
	pass
