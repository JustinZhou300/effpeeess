extends lamp_state
class_name lamp_flashing

var flicker_timer: float

func enter():
	flicker_timer = 0
	
func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	lamp.light.light_energy = sin(lamp.flash_period * delta) + 1
	if lamp.lamp_mode != 1:
		transition_to_state("lamp_on")
	#if flicker_timer >= lamp.flash_period and roll == 0:
		#if lamp.light.visible == true:
			#lamp.light.visible = false
		#elif flicker_timer >= lamp.flash_period:
			#lamp.light.visible = true
		#else:
			#lamp.light.visible = true
		#flicker_timer = 0
