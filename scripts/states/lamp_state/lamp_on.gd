extends lamp_state
class_name lamp_on



func enter():
	lamp.light.visible = true
	
func exit():
	pass

func update(delta):
	print("lamp")
	#if lamp.lamp_mode == 2:
		#print("transitioning to flickering")
		#transition_to_state("lamp_flickering")
	
	
func physics_update(delta):
	if lamp.light.visible == false:
		lamp.light.visible = true
