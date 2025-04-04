extends item_state
class_name item_inventory


func enter():
	item.item_model.visible = false
	item.weapon_model.visible = false
	
func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	pass
