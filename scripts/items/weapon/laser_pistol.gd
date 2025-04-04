extends RigidBody3D

var ammo: int
var magazine_capacity

var biped = null

#state variables
var is_spawning: bool = true
var is_equipped: bool = false
var is_stowed: bool = false
var is_stored: bool = false

@onready var weapon_model = $weapon_model
@onready var item_model = $item_model
@onready var collider = $CollisionShape3D

# Called when the node enters thea scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if is_equipped:
		#print('held gently')
		##position = 

func changeOwnership(desired_biped, yesno: bool):
	if yesno:
		self.reparent(desired_biped.gun_loc)
		biped = desired_biped
		biped.inventory.equipped = self
	else:
		self.reparent(GAME.WORLD.ITEMS)
		biped = null
		biped.inventory.equipped = null
	

func interact(interacter):
	changeOwnership(interacter, true)
	is_equipped = true
#func set_state(state: String):
	#if state == "equipped":
		#
	#elif state == "stowed":
		#
	#elif state == "inventory":
		#
	#elif state == "object":
		#
