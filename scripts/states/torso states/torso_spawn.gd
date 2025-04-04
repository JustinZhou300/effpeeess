extends torso_state
class_name torso_spawn



func enter():
	pass

func exit():
	pass

func update(delta):
	if GAME.WORLD.loaded == true:
		transition_to_state("torso_unarmed")

func physics_update(delta):
	pass
