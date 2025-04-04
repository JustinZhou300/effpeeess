extends Node
class_name State

signal Transitioned
@onready var handler = $"../"
@onready var biped = $"../../"

@export var state_movement: String
@export var state_no_movement: String
@export var state_grounded: String
@export var state_airbourne: String
@export var state_sprint: String
@export var state_crouch: String


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
	if state_movement:
		if biped.input_dir != Vector2(0, 0):
			transition_to_state(state_movement)
	if state_no_movement:
		if biped.input_dir == Vector2(0, 0):
			transition_to_state(state_no_movement)
	if state_grounded:
		if biped.stats.is_grounded:
			transition_to_state(state_grounded)
	if state_airbourne:
		if !biped.stats.is_grounded:
			transition_to_state(state_airbourne)
	if state_sprint:
		if Input.is_action_just_pressed("Sprint"):
			transition_to_state(state_sprint)
	if state_crouch:
		if Input.is_action_just_pressed("Crouch"):
			transition_to_state(state_crouch)
	
