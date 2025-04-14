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
	
	
	#if out of range, approach
	if entity.targets[0].global_position.distance_to(entity.global_position) > 1:
		transition_to_state("enemy_approach")
	
	#else melee
	else:
		transition_to_state("enemy_melee")
