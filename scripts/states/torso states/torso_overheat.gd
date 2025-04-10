extends torso_state
class_name torso_overheat

#var timer: float = 0
#var reload_time: float = 1
#var reload_proc_time: float = 0.5

func enter():
	#biped.model_anim.reload()
	biped.model_anim.overheat_blend(true)
	biped.inventory.equipped.venting = true
	biped.inventory.equipped.overheat_effect.emitting = true
	#timer = 0

func exit():
	biped.model_anim.overheat_blend(false)
	biped.inventory.equipped.venting = false
	biped.inventory.equipped.overheat_effect.emitting = false

func update(delta):
	#timer += delta
	if biped.inventory.equipped.heat < 0:
		transition_to_state("torso_idle")

func physics_update(delta):
	pass
