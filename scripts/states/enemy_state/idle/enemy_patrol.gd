extends enemy_state
class_name enemy_patrol

var target
var patrol_node
var active: bool

func enter():
	active = true
	patrol_node = entity.patrols[randi() % entity.patrols.size()]
	target = patrol_node.global_position
	entity.nav.target_position = target

func exit():
	target = Vector3(0, 0, 0)
	active = false
	patrol_node = null

func update(delta):
	pass

func physics_update(delta):
	if active:
		if entity.alerts.size() != 0:
			transition_to_state("enemy_alert")
		elif entity.targets.size() != 0:
			transition_to_state("enemy_combat")
		entity.check_view()
		
		#if entity.global_position.distance_to(target) < 1:
			#entity.patrols.remove_at(0)
			#transition_to_state("enemy_idle")
		if entity.nav.is_navigation_finished():
			#entity.remove_patrol_point(patrol_node)
			transition_to_state("enemy_idle")
		
		target_position = entity.nav.get_next_path_position()
		
		dir = entity.global_position.direction_to(target_position)
		#entity.velocity = dir * entity.SPEED_RUN
		entity.DESIRED_ROTATION = entity.get_desired_angle(target_position)
		entity.velocity = lerp(entity.velocity, entity.stats.SPEED_RUN / 1.5 * Vector3(dir.x, entity.velocity.y, dir.z) , 0.5)


var dir
var target_position
