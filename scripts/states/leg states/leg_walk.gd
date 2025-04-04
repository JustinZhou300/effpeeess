extends leg_state
class_name leg_walk

func enter():
	if biped.stats.is_crouched:
		biped.toggle_crouch(false)
	
func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	
	
	biped.velocity = lerp(biped.velocity, biped.direction * biped.stats.SPEED_RUN, biped.stats.SPEED_ACCELERATION * delta)
