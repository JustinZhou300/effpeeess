extends enemy_state
class_name enemy_stun

var stun_time = 1
var stun_timer = 0
var active: bool

func enter():
	active = true
	entity.model_anim.stun_blend(true)
	stun_timer = 0

func exit():
	entity.model_anim.stun_blend(false)
	entity.stats.poise_current = 0
	entity.stats.is_stunned = false
	active = false

func update(delta):
	pass
	
func physics_update(delta):
	if active:
		entity.velocity = lerp(entity.velocity, Vector3(0, entity.velocity.y, 0), 0.05)
		stun_timer += delta
		print(stun_timer)
		if stun_timer >= stun_time:
			transition_to_state("enemy_idle")
			print(stun_timer)
