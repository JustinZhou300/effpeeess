extends Node

@export var initial_state : torso_state

var current_state: torso_state
var states: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is torso_state:
			states[child.name.to_lower()] = child
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state.switch_state()
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		print("called by a state that is not the right state")
		return
	
	var newState = states.get(new_state_name.to_lower())
	if !newState:
		print("there is no state of name: " + str(new_state_name))
		return
	
	if current_state:
		current_state.exit()
	
	newState.enter() 
	current_state = newState
