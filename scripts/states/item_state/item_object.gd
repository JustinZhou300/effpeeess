extends item_state
class_name item_object

var scale_factor = 1.2

func enter():
	item.model.visible = true
	item.model.scale *= scale_factor
	item.collider.shape.size *= scale_factor
	item.collider.disabled = false
	
	#20 * (biped.global_position - biped.shoot_ray.get_collision_point().normalized())
func exit():
	item.model.visible = false
	item.collider.disabled = true
	item.model.scale /= scale_factor
	item.collider.shape.size /= scale_factor

func update(delta):
	pass
	
func physics_update(delta):
	pass
