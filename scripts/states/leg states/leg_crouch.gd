extends leg_state
class_name leg_crouch


func enter():
	if !biped.stats.is_crouched:
		biped.toggle_crouch(true)
	
func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	biped.velocity = lerp(biped.velocity, biped.direction * biped.stats.SPEED_CROUCH, biped.stats.SPEED_ACCELERATION * delta)
