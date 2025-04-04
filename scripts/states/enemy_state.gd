extends Node
class_name enemy_state

signal Transitioned
@onready var handler = $"../"
@onready var entity = $"../../"


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
	print("enemy state transition to " + new_state + ", from " + str(self))

func switch_state():
	if entity.stats.is_stunned and !entity.stats.is_KO and !entity.stats.is_dead:
		transition_to_state("enemy_stun")
	if entity.stats.is_KO and !entity.stats.is_dead and handler.current_state.name != "enemy_KO":
		transition_to_state("enemy_KO")
	if entity.stats.is_dead and handler.current_state.name != "enemy_dead":
		transition_to_state("enemy_dead")
	
