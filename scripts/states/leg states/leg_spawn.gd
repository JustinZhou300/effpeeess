extends leg_state
class_name leg_spawn



func enter():
	pass
	
func exit():
	pass

func update(delta):
	if GAME.WORLD.loaded == true:
		transition_to_state("leg_idle")
	
func physics_update(delta):
	biped.velocity = Vector3(0,0,0)
