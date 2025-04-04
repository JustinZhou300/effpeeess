extends torso_state
class_name torso_dead

func enter():
	biped.stats.can_interact = false
	biped.stats.is_aiming = false
	
func exit():
	biped.stats.can_interact = false
	biped.stats.is_aiming = false

func update(delta):
	pass

func physics_update(delta):
	pass
