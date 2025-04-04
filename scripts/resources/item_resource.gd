extends Resource
class_name item_resource

enum animation_sets {one_handed, two_handed}
#GENERIC ITEM PARAMETERS
@export_subgroup("Generic Item Parameters")
@export var item_name: String
@export var item_description: String

@export var item_health: int
@export var max_stack: int #The amount the item can be stacked.

@export var is_weapon: bool
@export var is_breakable: bool
@export var is_usabled: bool #Can you use the item? Potions etc.


#WEAPON PARAMETERS
@export_subgroup("Weapon Parameters")
@export var can_fire: bool = true
@export var animation_set: animation_sets
@export var damage: int
@export var stagger_damage: int

@export var firing_rpm: int
@export var is_automatic: bool = false
@export var burst_amount: int = 1 #the amount fired per trigger pull.
@export var magazine_size: int #how many bullets in a magazine
@export var ammo_name: String #the name of the ammo type, will check inventory for it.

#Stability
@export var recoil_amount: int #the amount of recoil idk
#Handling
@export var stow_speed: float = 1 #how long to stow weapon in seconds
@export var draw_speed: float = 1 #how long to draw weapon in seconds
#Reload
@export var reload_speed: float = 1 #how long to reload weapon in seconds

@export_subgroup("Model Parameters")
@export var item_model: PackedScene #model for the item
@export var weapon_model: PackedScene #weapon model. should have functionality attached.
@export var projectile_model: PackedScene #the projectile in the case that it is a projectile firing weapon.
