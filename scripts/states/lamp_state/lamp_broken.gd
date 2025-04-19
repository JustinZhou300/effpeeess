extends lamp_state
class_name lamp_broken



func enter():
	lamp.light.visible = false
	
func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	pass
