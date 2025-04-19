extends lamp_state
class_name lamp_flickering

var flicker_timer: float
var flicker: bool = false

func enter():
	flicker_timer = 0
	flicker = true
	
func exit():
	flicker = false

func update(delta):
	pass
	
func physics_update(delta):
	if flicker:
		flicker_timer += delta
		var roll = randi_range(0, lamp.flicker_amount) #whether to turn off this frame
		if flicker_timer >= lamp.flash_period and roll == 0:
			if lamp.light.visible == true:
				lamp.light.visible = false
			elif flicker_timer >= lamp.flash_period:
				lamp.light.visible = true
			else:
				lamp.light.visible = true
			flicker_timer = 0
