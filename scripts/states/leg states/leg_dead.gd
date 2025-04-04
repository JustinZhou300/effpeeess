extends leg_state
class_name leg_dead



func enter():
	if biped.stats.is_crouched:
		biped.toggle_crouch(false)
	biped.model_anim.set_death(true)

func exit():
	biped.model_anim.set_death(false)

func update(delta):
	pass
	
func physics_update(delta):
	biped.velocity = lerp(biped.velocity, Vector3(0,biped.velocity.y,0), biped.stats.SPEED_ACCELERATION * delta)
