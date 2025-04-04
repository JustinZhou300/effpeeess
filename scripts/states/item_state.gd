extends Node
class_name item_state

signal Transitioned
@onready var item = $"../.."
@onready var handler = $".."



func enter():
	pass
	
func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	pass

func transition_to_state(new_state):
	handler.on_child_transition(self, new_state)

#func switch_state():
	#if !item.is_spawning:
		#if item.is_equipped:
			#transition_to_state("item_equipped")
		#elif item.is_stowed:
			#transition_to_state("item_stowed")
		#elif item.is_stored:
			#transition_to_state("item_inventory")
		#else:
			#transition_to_state("item_object")
	
