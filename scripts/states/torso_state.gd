extends Node
class_name torso_state

signal Transitioned
@onready var handler = $"../"
@onready var biped = $"../../"


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
	#print("torso state transition to " + new_state + ", from " + str(self))

func switch_state():
	pass
	
