extends door_state
class_name door_locked


func enter():
	door.set_door_monitor(1)
	door.nav_link.enabled = false
	
func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	pass
