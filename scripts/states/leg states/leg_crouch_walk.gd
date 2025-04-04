extends leg_state
class_name leg_crouch_walk

func enter():
	if !biped.stats.is_crouched:
		biped.toggle_crouch(true)
	
func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	
	#var direction = (biped.transform.basis * Vector3(biped.input_dir.x, 0, biped.input_dir.y)).normalized()
	#if biped.direction:
		#biped.velocity.x = biped.direction.x * biped.SPEED_WALK
		#biped.velocity.z = biped.direction.z * biped.SPEED_WALK
	#else:
		#biped.velocity.x = move_toward(biped.velocity.x, 0, biped.SPEED_WALK)
		#biped.velocity.z = move_toward(biped.velocity.z, 0, biped.SPEED_WALK)
	biped.velocity = lerp(biped.velocity, biped.direction * biped.stats.SPEED_CROUCH, biped.stats.SPEED_ACCELERATION * delta)
	#move_and_slide()
