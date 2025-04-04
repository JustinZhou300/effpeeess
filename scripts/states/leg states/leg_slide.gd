extends leg_state
class_name leg_slide

var slide_timer: float = 0
var slide_velocity: Vector3
var slide_drag = 0.01

func enter():
	biped.stats.is_sliding = true
	slide_velocity = Vector3(0, 0, 0)
	var slide_direction = (biped.playerView.transform.basis * Vector3(biped.input_dir.x, 0, biped.input_dir.y))
	if !biped.stats.is_crouched:
		biped.toggle_crouch(true)
	slide_timer = 0
	slide_velocity.x += slide_direction.x
	slide_velocity.z += slide_direction.z 
	slide_velocity.y = biped.velocity.y
	slide_velocity *= biped.stats.SPEED_SLIDE 
	biped.stats.is_sliding = true
	#biped.can_jump = false
	biped.FOV_modifier += 20
	biped.model_anim.set_slide(true)
	
	
func exit():
	biped.stats.is_sliding = false
	#biped.can_jump = true
	biped.FOV_modifier -= 20
	biped.model_anim.set_slide(false)

func update(delta):
	pass
	
func physics_update(delta):
	
	slide_timer += delta
	if slide_timer >= biped.stats.TIMER_SLIDE and biped.direction != Vector3(0, 0, 0):
		transition_to_state("leg_crouch")
	slide_velocity = lerp(slide_velocity, biped.direction, slide_drag)
	if biped.velocity.length() < biped.stats.SPEED_CROUCH:
		transition_to_state("leg_crouch")
	
	biped.velocity = slide_velocity
	#var direction = (biped.transform.basis * Vector3(biped.input_dir.x, 0, biped.input_dir.y)).normalized()
	#if biped.direction:
		#biped.velocity.x = biped.direction.x * biped.SPEED_WALK
		#biped.velocity.z = biped.direction.z * biped.SPEED_WALK
	#else:
		#biped.velocity.x = move_toward(biped.velocity.x, 0, biped.SPEED_WALK)
		#biped.velocity.z = move_toward(biped.velocity.z, 0, biped.SPEED_WALK)
	
	#move_and_slide()
