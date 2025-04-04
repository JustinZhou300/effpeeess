extends item_state
class_name item_object


func enter():
	item.model.visible = true
	
	item.collider.disabled = false
	
	#20 * (biped.global_position - biped.shoot_ray.get_collision_point().normalized())
func exit():
	item.model.visible = false
	item.collider.disabled = true

func update(delta):
	pass
	
func physics_update(delta):
	pass
