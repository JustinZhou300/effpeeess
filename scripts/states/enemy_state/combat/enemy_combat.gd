extends enemy_state
class_name enemy_combat


func enter():
	pass

func exit():
	pass

func update(delta):
	pass

func physics_update(delta):
	
	entity.check_view()
	
	if entity.targets == []:
		transition_to_state("enemy_idle")
	
	if entity.targets[0].global_position.distance_to(entity.global_position) > 1:
		transition_to_state("enemy_approach")
	else:
		transition_to_state("enemy_melee")
