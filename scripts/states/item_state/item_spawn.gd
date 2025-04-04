extends item_state
class_name item_spawn


func enter():
	item.sleeping = true
	item.gravity_scale = 0
	
func exit():
	item.model.visible = true
	item.sleeping = false
	item.gravity_scale = 1

func update(delta):
	if GAME.WORLD.loaded:
		print("spawning_item")
		transition_to_state("item_object")
	
func physics_update(delta):
	pass
