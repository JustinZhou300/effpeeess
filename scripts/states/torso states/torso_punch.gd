extends torso_state
class_name torso_punch

var timer: float = 0
var punch_time: float = 0.1#0.1 - 0.33
var has_punched_again: bool  = false

func enter():
	biped.model_anim.punch()
	timer = 0
	has_punched_again = false

func exit():
	pass

func update(delta):
	timer += delta
	
	if Input.is_action_just_pressed("Primary_Fire"):
		has_punched_again = true
	
	if timer >= punch_time:
		if has_punched_again:
			transition_to_state("torso_punch")
		else:
			transition_to_state("torso_unarmed")

func physics_update(delta):
	pass
