extends item_state
class_name item_equipped

var weapon_model
var weapon_model_anim
var weapon_model_firing_loc

func enter():
	
	#hide item model
	item.model.visible = false
	
	#create weapon model attached to player hand
	weapon_model = item.model.duplicate()
	weapon_model_anim = weapon_model.get_child(0)
	if item.is_gun:
		weapon_model_firing_loc = item.firing_location.duplicate()
		print(weapon_model.find_child("firing_loc"))
		item.current_firing_location = weapon_model_firing_loc
	item.biped.gun_loc.add_child(weapon_model)
	print("rotation: " + str(weapon_model.rotation))
	weapon_model.add_child(weapon_model_firing_loc)

	weapon_model.visible = true
	
	#item.weapon_model
	#item.biped.model_anim.gun_loc.add_child()
	item.collider.disabled = true
	
func exit():
	item.model.global_rotation = weapon_model.global_rotation
	weapon_model.queue_free()
	item.model.visible = true
	if item.is_gun: item.current_firing_location = item.firing_location
	item.model.rotation = Vector3(0, 0, 0)

func update(delta):
	#print(weapon_model.rotation)
	#print(weapon_model.global_rotation)
	if item.biped.shoot_ray.is_colliding() and item.biped.stats.is_aiming:
		weapon_model.look_at(item.biped.shoot_ray.get_collision_point())
		weapon_model.global_rotation += Vector3(0, 0, item.biped.model_anim.head_pos.global_rotation.z)
		item.look_at(item.biped.shoot_ray.get_collision_point())
		item.global_rotation += Vector3(0, 0, item.biped.model_anim.head_pos.global_rotation.z)
	else:
		weapon_model.rotation = Vector3(90, 0, 0)
		weapon_model.global_rotation += Vector3(0, 0, item.biped.model_anim.head_pos.global_rotation.z)
		item.rotation = Vector3(90, 0, 0)
		item.global_rotation += Vector3(0, 0, item.biped.model_anim.head_pos.global_rotation.z)
	#if item.biped != null:
		#item.global_position = item.biped.gun_loc.global_position
		#if item.biped.is_aiming:
			#if item.biped.shoot_ray.is_colliding():
				#item.look_at(item.biped.shoot_ray.get_collision_point())
				#item.global_rotation += Vector3(0, 0, item.biped.model_anim.head_pos.global_rotation.z)
			#else:
				#item.global_rotation = lerp(item.global_rotation, item.biped.gun_loc.global_rotation, 1)
			#
		#else:
			#item.global_rotation = lerp(item.global_rotation, item.biped.gun_loc.global_rotation, 1)
	
func physics_update(delta):
	pass
