extends door_state
class_name door_spawn


func enter():
	pass
	
func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	if GAME.WORLD.loaded:
		transition_to_state(door.starting_state)
