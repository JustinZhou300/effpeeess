extends leg_state
class_name leg_mantle

var wall_normal: Vector3

func enter():
	if biped.stats.is_crouched:
		biped.toggle_crouch(false)
	
	wall_normal = biped.wallHit.get_collision_normal()
	biped.stats.is_mantle = true
	biped.velocity.y = 0
	biped.velocity.y = lerp(biped.velocity.y, float(biped.stats.SPEED_MANTLE), 1)
	biped.mantle_ray.target_position = Vector3(0, -1.5, 0)
	biped.mantle_ray_r.target_position = Vector3(0, -1.5, 0)
	biped.mantle_ray_l.target_position = Vector3(0, -1.5, 0)
	
func exit():
	biped.stats.is_mantle = false
	biped.mantle_ray.target_position = Vector3(0, -0.5, 0)
	biped.mantle_ray_r.target_position = Vector3(0, -0.5, 0)
	biped.mantle_ray_l.target_position = Vector3(0, -0.5, 0)

func update(delta):
	#print("direciton: " + str(biped.direction))
	#print("mantle: " + str(biped.mantle_ray.target_position))
	#print("vel: " + str(biped.velocity))
	#print(abs(rad_to_deg((acos((wall_normal.dot(biped.direction)/(wall_normal.length() * biped.direction.length()))))) - 180))
	if biped.stats.is_grounded:
		transition_to_state("leg_idle")
	if !biped.mantle_ray.is_colliding():
		transition_to_state("leg_idle")
	if biped.input_dir == Vector2(0, 0) or abs(rad_to_deg((acos((wall_normal.dot(biped.direction)/(wall_normal.length() * biped.direction.length()))))) - 180) > 30:
		transition_to_state("leg_airbourne")
	
func physics_update(delta):
	#biped.velocity += biped.direction * biped.SPEED_AIR * delta
	#biped.velocity = lerp(biped.velocity, biped.direction * biped.SPEED_SPRINT, biped.SPEED_AIR_ACCELERATION * delta)
	biped.velocity.x = lerp(biped.velocity.x, 0.0, 0.5)
	biped.velocity.z = lerp(biped.velocity.z, 0.0, 0.5)
	biped.velocity.y = lerp(biped.velocity.y, float(biped.stats.SPEED_MANTLE), 1)
