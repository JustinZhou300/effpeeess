extends torso_state
class_name torso_stow

var timer: float = 0
var stow_time: float = 1

func enter():
	stow_time = biped.inventory.equipped.stow_speed
	biped.model_anim.set_animation_speed("stow", stow_time)
	if biped.inventory.equipped.has_animations:
		biped.inventory.equipped.model_anim.set_animation_speed("stow", stow_time)
		biped.inventory.equipped.model_anim.set_stow(true)
	timer = 0 
	biped.model_anim.stow()
	
func exit():
	
	#set weapon animations off
	if biped.inventory.equipped.has_animations:
		biped.inventory.equipped.model_anim.set_animation_speed("stow", stow_time)
		biped.inventory.equipped.model_anim.set_stow(false)
	
	biped.inventory.equipped.state_handler.current_state.transition_to_state("item_stowed") #item_state>stow
	biped.inventory.temp_slot = biped.inventory.equipped  #temp store equipped
	biped.inventory.equipped = null #equipped is now empty
	
	if biped.inventory.stow_slots[biped.inventory.swap_position] == null:
		biped.inventory.stow_slots[biped.inventory.swap_position] = biped.inventory.temp_slot
		biped.inventory.temp_slot = null
	else:
		biped.inventory.equipped = biped.inventory.stow_slots[biped.inventory.swap_position]
		biped.inventory.equipped.state_handler.current_state.transition_to_state("item_equipped")
		biped.inventory.stow_slots[biped.inventory.swap_position] = biped.inventory.temp_slot
		
	biped.inventory.swap_position = -1
	

func update(delta):
	timer += delta
	if timer >= stow_time:
		transition_to_state("torso_unarmed")
	
func physics_update(delta):
	pass
