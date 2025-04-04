extends enemy_state
class_name enemy_KO



func enter():
	#entity.model_anim.death_blend(true)
	entity.model_anim.die()
	entity.DESIRED_ROTATION = entity.CURRENT_ROTATION
	entity.DESIRED_SPEED = 0
	entity.stats.set_collider(false)

func exit():
	entity.model_anim.death_blend(false)
	entity.stats.set_collider(true)

func update(delta):
	pass
	
func physics_update(delta):
	#entity.DESIRED_SPEED = 0
	#entity.DESIRED_ROTATION = entity.CURRENT_ROTATION
	entity.velocity.x = lerp(entity.velocity.x, 0.0, 0.5)
	entity.velocity.z = lerp(entity.velocity.z, 0.0, 0.5)
