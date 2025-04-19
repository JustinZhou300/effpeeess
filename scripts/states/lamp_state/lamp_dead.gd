extends lamp_state
class_name lamp_dead



func enter():
	lamp.light.visible = false
	
func exit():
	pass

func update(delta):
	if lamp.stats.is_powered:
		transition_to_state("lamp_on")
	
func physics_update(delta):
	pass
