extends door_state
class_name door_open


func enter():
	door.set_door_monitor(0)
	door.nav_link.enabled = true
	
func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	if !door.check_area():
		door.door_close_timer += delta
	if door.door_close_timer > 2:
		door.is_open = false
		door.set_door_anim(false)
		transition_to_state("door_closed")
