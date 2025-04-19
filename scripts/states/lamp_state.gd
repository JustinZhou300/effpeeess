extends Node
class_name lamp_state

signal Transitioned
@onready var lamp = $"../.."
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
	print("lamp state transition to " + new_state + ", from " + str(self))

func switch_state():
	if handler.current_state.name != "lamp_spawn":
		if !lamp.stats.is_powered and handler.current_state.name != "lamp_dead":
			transition_to_state("lamp_dead")
		if lamp.stats.is_dead and handler.current_state.name != "lamp_broken":
			transition_to_state("lamp_broken")
