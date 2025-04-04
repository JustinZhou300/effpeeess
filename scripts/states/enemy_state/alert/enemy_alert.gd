extends enemy_state
class_name enemy_alert




func enter():
	pass

func exit():
	pass

func update(delta):
	if entity.alerts == []:
		transition_to_state("enemy_idle")
	elif entity.targets != []:
		transition_to_state("enemy_combat")
	
	

func physics_update(delta):
	entity.check_view()
