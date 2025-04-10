extends torso_state
class_name torso_reload

var timer: float = 0
var reload_time: float = 1
var reload_proc_time: float = 0.5
var has_reloaded: bool

func enter():
	biped.model_anim.reload()
	timer = 0
	has_reloaded = false
	if biped.inventory.equipped.has_animations:
		biped.inventory.equipped.model_anim.set_animation_speed("reload", reload_time)
		biped.inventory.equipped.model_anim.reload()

func exit():
	pass

func update(delta):
	timer += delta
	if timer >= reload_proc_time and !has_reloaded:
		biped.inventory.equipped.reload()
		has_reloaded = true
	if timer > 1:
		transition_to_state("torso_idle")
	if biped.aim_wall_hit.is_colliding() or biped.arm_wall_hit.is_colliding():
		transition_to_state("torso_walled")
	
func physics_update(delta):
	pass
