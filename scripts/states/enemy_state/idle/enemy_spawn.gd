extends enemy_state
class_name enemy_spawn


func enter():
	pass

func exit():
	pass

func update(delta):
	if GAME.WORLD.loaded == true:
		transition_to_state("enemy_idle")
	
func physics_update(delta):
	entity.velocity = Vector3(0, 0, 0)
