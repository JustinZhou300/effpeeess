extends leg_state
class_name leg_sprint_airbourne

var transition_to_slide: bool = false

func enter():
	transition_to_slide = false
	biped.FOV_modifier += 10
	biped.stats.is_sprinting = true
func exit():
	biped.FOV_modifier -= 10
	biped.stats.is_sprinting = false

func update(delta):
	if Input.is_action_just_pressed("Crouch"):
			transition_to_slide = true
	if !biped.stats.is_grounded and biped.check_mantle() and biped.inventory.equipped == null and biped.input_dir.length() > 0:
		transition_to_state("leg_mantle")
	
func physics_update(delta):
	#biped.velocity = lerp(biped.velocity, biped.direction * biped.SPEED_SPRINT, biped.SPEED_AIR_ACCELERATION * delta)
	biped.velocity.x = lerp(biped.velocity.x, biped.direction.x * biped.stats.SPEED_SPRINT, biped.stats.SPEED_AIR_ACCELERATION * delta)
	biped.velocity.z = lerp(biped.velocity.z, biped.direction.z * biped.stats.SPEED_SPRINT, biped.stats.SPEED_AIR_ACCELERATION * delta)
	
	#biped.velocity += biped.direction * biped.SPEED_AIR * delta
	
	if transition_to_slide and biped.stats.is_grounded:
		transition_to_state("leg_slide")
	elif biped.stats.is_grounded:
		transition_to_state("leg_sprint")
	
	
	#biped.velocity.y -= delta * biped.GRAVITY
#
	#move_and_slide()
