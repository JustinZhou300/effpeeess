extends enemy_state
class_name enemy_melee

var timer
var melee_time = 1

func enter():
	timer = 0
	entity.model_anim.melee_oneshot(randi() % 3)
	

func exit():
	pass

func update(delta):
	pass

func physics_update(delta):
	entity.velocity = lerp (entity.velocity, Vector3(0, entity.velocity.y, 0), 1)
	timer += delta
	if timer >= melee_time:
		transition_to_state("enemy_combat")
