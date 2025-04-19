extends door_state
class_name door_broken


func enter():
	door.set_door_monitor(2)
	
func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	pass
