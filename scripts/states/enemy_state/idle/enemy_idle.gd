extends enemy_state
class_name enemy_idle


func enter():
	pass

func exit():
	pass

func update(delta):
	if entity.alerts.size() != 0:
		transition_to_state("enemy_alert")
	elif entity.targets.size() != 0:
		transition_to_state("enemy_combat")
	elif entity.patrols.size() != 0:
		transition_to_state("enemy_patrol")
	elif entity.patrols == []:
		entity.patrols = GAME.WORLD.MISSION.PATROL_POINTS

func physics_update(delta):
	entity.check_view()
	entity.velocity = lerp(entity.velocity, Vector3(0, entity.velocity.y, 0), 0.5)
