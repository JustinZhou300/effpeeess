extends torso_state
class_name torso_draw

var timer: float = 0
var draw_time: float = 1

func enter():
	
	biped.inventory.equipped.state_handler.current_state.transition_to_state("item_equipped")
	draw_time = biped.inventory.equipped.draw_speed
	biped.model_anim.set_animation_speed("draw", draw_time)
	
	timer = 0
	biped.model_anim.draw()
	biped.model_anim.weapon_blend(true)
	biped.model_anim.unarmed_blend(false)
	biped.model_anim.set_weapon_anim_set(biped.inventory.equipped.animation_set)
	
	if biped.inventory.equipped.has_animations:
		biped.inventory.equipped.model_anim.set_animation_speed("draw", draw_time)
		biped.inventory.equipped.state_handler.current_state.weapon_model_anim.set_draw(true)
	


func exit():
	biped.inventory.swap_position = -1
	if biped.inventory.equipped.has_animations:
		biped.inventory.equipped.state_handler.current_state.weapon_model_anim.set_draw(false)

func update(delta):
	timer += delta
	if timer >= draw_time:
		if biped.stats.is_sprinting:
			transition_to_state("torso_sprint")
		else:
			transition_to_state("torso_idle")
	
func physics_update(delta):
	pass


#code graveyard
#if biped.inventory.swap_position == 1:
		#biped.inventory.temp_slot = biped.inventory.equipped 
		#biped.inventory.equipped = biped.inventory.slot1
		#biped.inventory.slot1 = biped.inventory.temp_slot
		#if biped.inventory.slot1 != null:
			#biped.inventory.slot1.is_equipped = false
			#biped.inventory.slot1.is_stowed = true
		#biped.inventory.temp_slot = null
	#elif biped.inventory.swap_position == 2:
		#biped.inventory.temp_slot = biped.inventory.equipped 
		#biped.inventory.equipped = biped.inventory.slot2
		#biped.inventory.slot2 = biped.inventory.temp_slot
		#if biped.inventory.slot2 != null:
			#biped.inventory.slot2.is_equipped = false
			#biped.inventory.slot2.is_stowed = true
		#biped.inventory.temp_slot = null
	#elif biped.inventory.swap_position == 3:
		#biped.inventory.temp_slot = biped.inventory.equipped 
		#biped.inventory.equipped = biped.inventory.slot3
		#biped.inventory.slot3 = biped.inventory.temp_slot
		#if biped.inventory.slot3 != null:
			#biped.inventory.slot3.is_equipped = false
			#biped.inventory.slot3.is_stowed = true
		#biped.inventory.temp_slot = null
	#biped.inventory.equipped.is_equipped = true
	#biped.inventory.equipped.is_stowed = false
