extends enemy_state
class_name enemy_investigate

#the position the enemy will investigate+
var target:Vector3


func enter():
	target = entity.alerts[0]
	

func exit():
	target = Vector3(0, 0, 0)

func update(delta):
	entity.nav.target_position = target
	
	if entity.global_position.distance_to(target) < 1:
		transition_to_state("enemy_combat")
	
	target_position = entity.nav.get_next_path_position()

var dir
var target_position

func physics_update(delta):
	entity.check_view()
	dir = entity.global_position.direction_to(target_position)
	#entity.velocity = dir * entity.SPEED_RUN
	entity.DESIRED_ROTATION = entity.get_desired_angle(target_position)
	entity.velocity = lerp(entity.velocity, entity.stats.SPEED_RUN / 1.5 * Vector3(dir.x, 0, dir.z) , 0.5)
	
