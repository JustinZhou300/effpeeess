extends torso_state
class_name torso_mantle

func enter():
	biped.model_anim.mantle()
	biped.model_anim.set_hands("palm")
	
func exit():
	pass

func update(delta):
	if !biped.stats.is_mantle:
		transition_to_state("torso_unarmed")
	
func physics_update(delta):
	pass
