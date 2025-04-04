extends torso_state
class_name torso_throw

var timer = 0
var state_length = 0.2
var throw_time = state_length * 0.5 #time until the object is thrown
var has_thrown
var thrown_weapon

func enter():
	has_thrown = false
	biped.model_anim.throw()
	biped.model_anim.throw_speed(state_length)
	timer = 0
	thrown_weapon = biped.inventory.equipped
	print(thrown_weapon)

func exit():
	thrown_weapon = null

func update(delta):
		pass
	

func throw_held():
	var thrown_obj = biped.inventory.equipped
	print(thrown_obj)
	print(biped.inventory.equipped)
	biped.inventory.drop_weapon()
	print(thrown_obj)
	print(biped.playerViewRay.global_transform.basis.z)
	thrown_obj.global_position = biped.gun_loc.global_position
	print("test: " + str(biped.aim_ray.global_position - biped.aim_ray.get_collision_point().normalized()))
	thrown_obj.linear_velocity = Vector3(0, 0, 0)
	thrown_obj.angular_velocity = Vector3(0, 0, 0)
	#thrown_obj.rotation = Vector3(0, 0, 0)
	thrown_obj.apply_central_impulse((-biped.playerViewCamera.global_transform.basis.z) * biped.stats.throw_force * 10)

func physics_update(delta):
	timer += delta
	if timer >= state_length:
		transition_to_state("torso_unarmed")
	if timer >= throw_time and !has_thrown:
		throw_held()
		has_thrown = true
