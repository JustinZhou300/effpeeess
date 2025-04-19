extends door_state
class_name door_dead


func enter():
	door.set_door_monitor(3)
	door.nav_link.enabled = false

func exit():
	pass

func update(delta):
	if door.stats.is_powered:
		transition_to_state("door_closed")
	
func physics_update(delta):
	pass
