extends door_state
class_name door_closed


func enter():
	door.set_door_monitor(0)
	door.nav_link.enabled = true
	
func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	if door.check_area():
			door.is_open = true
			door.door_close_timer = 0
			door.set_door_anim(true)
			transition_to_state("door_open")
