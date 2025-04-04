extends leg_state
class_name leg_sprint

func enter():
	if biped.stats.is_crouched:
		biped.toggle_crouch(false)
	biped.FOV_modifier += 20
	biped.stats.is_sprinting = true
	
func exit():
	biped.FOV_modifier -= 20
	biped.stats.is_sprinting = false

func update(delta):
	if (biped.direction.length() < 0.75 or (rad_to_deg(acos(biped.direction.normalized().dot(biped.playerView.transform.basis*Vector3(0, 0, -1)))) > 60)) or Input.is_action_just_pressed("Primary_Fire") or Input.is_action_just_pressed("Secondary_Fire"):
		transition_to_state("leg_walk")
	
func physics_update(delta):
	
	#var direction = (biped.transform.basis * Vector3(biped.input_dir.x, 0, biped.input_dir.y)).normalized()
	#if biped.direction:
		#biped.velocity.x = biped.direction.x * biped.SPEED_WALK
		#biped.velocity.z = biped.direction.z * biped.SPEED_WALK
	#else:
		#biped.velocity.x = move_toward(biped.velocity.x, 0, biped.SPEED_WALK)
		#biped.velocity.z = move_toward(biped.velocity.z, 0, biped.SPEED_WALK)
	biped.velocity = lerp(biped.velocity, biped.direction * biped.stats.SPEED_SPRINT, biped.stats.SPEED_ACCELERATION * delta)
	#move_and_slide()
