extends lamp_state
class_name lamp_spawn



func enter():
	pass
	
func exit():
	pass

func update(delta):
	if GAME.WORLD.loaded:
		print("spawn state transition to " + str(lamp.starting_state))
		transition_to_state(lamp.starting_state)
	
func physics_update(delta):
	pass
