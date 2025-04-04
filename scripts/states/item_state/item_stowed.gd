extends item_state
class_name item_stowed

var stow_slot_number

func enter():
	item.collider.disabled = true
	item.model.visible = true
	#item.is_stowed = true
	
	
func exit():
	item.model.visible = false

func update(delta):
	pass
	
func physics_update(delta):
	pass
