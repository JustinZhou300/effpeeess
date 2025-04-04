extends RigidBody3D
class_name item_instance

#item variables
@export var resource: item_resource
#weapon variables


#owner parameters
var biped = null

#state variables
var is_spawning: bool = true
#var is_equipped: bool = false
#var is_stowed: bool = false
#var is_stored: bool = false

#node variables
var collider
var state_handler
var weapon_model
var item_model

# Called when the node enters thea scene tree for the first time.
func _ready() -> void:
	
	name = resource.item_name
	continuous_cd = true #continuous collision detection on (stops from falling throuhg floor)
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(3, true)
	
	#create_state_handler()
	state_handler = load("res://scenes/items/item_subnodes/item_state_handler.tscn").instantiate()
	add_child(state_handler)
	
	#creating collider for object
	collider = CollisionShape3D.new()
	var box = BoxShape3D.new()
	box.extents = Vector3(0.338, 0.082, 0.269)
	collider.shape = box
	collider.position = Vector3(-0.012, 0.002, 0.048)
	add_child(collider)
	
	#adding relevant models and weapon functions
	if resource.is_weapon:
		weapon_model = resource.weapon_model.instantiate()
		add_child(weapon_model)
	item_model = resource.item_model.instantiate()
	add_child(item_model)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func changeOwnership(desired_biped, yesno: bool):
	#If yes, then add to equip (if nothing equipped) or inventory (if space)
	if yesno:
		biped = desired_biped
		if resource.is_weapon and biped.inventory.equipped == null: #if pick up weapon
			biped.inventory.equipped = self
			state_handler.current_state.transition_to_state("item_equipped")
			biped.torso_handler.current_state.transition_to_state("torso_draw")
		elif resource.is_weapon and biped.inventory.equipped != null: #if already holding something
			print("you already have something equipped.")
	else:
		state_handler.current_state.transition_to_state("item_object")
		position = biped.interact_ray.global_position
		biped = null
		

func interact(interacter):
	if resource.is_weapon:
		changeOwnership(interacter, true)
		#is_stowed = true

func set_model_visibility(model: String, yesno: bool):
	if model == "weapon":
		weapon_model.visible = yesno
	elif model == "item":
		item_model.visible = yesno
	else:
		push_error("incorrect string in set_model_visibility()")

#func fire():
	#if resource.can_fire:
		#print("bang!")
	#else:
		#pass
