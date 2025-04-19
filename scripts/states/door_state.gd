extends Node
class_name door_state

signal Transitioned
@onready var door = $"../.."
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

func switch_state():
	if handler.current_state.name != "door_spawn":
		if !door.stats.is_powered and handler.current_state.name != "door_dead":
			transition_to_state("door_dead")
		elif door.stats.is_locked and handler.current_state.name != "door_locked":
			transition_to_state("door_locked")
