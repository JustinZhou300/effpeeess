extends leg_state
class_name leg_crouch_airbourne

func enter():
	if !biped.stats.is_crouched:
		biped.toggle_crouch(true)
	
func exit():
	pass

func update(delta):
	if !biped.stats.is_grounded and biped.check_mantle() and biped.inventory.equipped == null:
		transition_to_state("leg_mantle")
	
func physics_update(delta):
	#biped.velocity = lerp(biped.velocity, biped.direction * biped.SPEED_SPRINT, biped.SPEED_AIR_ACCELERATION * delta)
	biped.velocity.x = lerp(biped.velocity.x, biped.direction.x * biped.stats.SPEED_SPRINT, biped.stats.SPEED_AIR_ACCELERATION * delta)
	biped.velocity.z = lerp(biped.velocity.z, biped.direction.z * biped.stats.SPEED_SPRINT, biped.stats.SPEED_AIR_ACCELERATION * delta)
	#biped.velocity += biped.direction * biped.SPEED_AIR * delta
	#biped.velocity.y -= delta * biped.GRAVITY #NOW IN biped script
#
	#move_and_slide()
