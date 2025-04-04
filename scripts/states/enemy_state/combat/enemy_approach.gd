extends enemy_state
class_name enemy_approach

var target 
var target_position

func enter():
	target = entity.targets[0]

func exit():
	pass

func update(delta):
	entity.nav.target_position = target.global_position
	
	if entity.global_position.distance_to(target.global_position) < 1:
		transition_to_state("enemy_combat")
	
	target_position = entity.nav.get_next_path_position()

var dir

func physics_update(delta):
	entity.check_view()
	dir = entity.global_position.direction_to(target_position)
	#entity.velocity = dir * entity.SPEED_RUN
	entity.DESIRED_ROTATION = entity.get_desired_angle(target_position)
	entity.velocity = lerp(entity.velocity, entity.stats.SPEED_RUN * Vector3(dir.x, 0, dir.z) , 0.5)
	
