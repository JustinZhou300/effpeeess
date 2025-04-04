extends Node

#Two kinds of inventory
#items like potions, quest items, whatever are 

#There is a slot based inventory, but only ammo, key items, medkits etc go here.
var inventory = []

var equipped: Node = null
var stow_slots = [null, null, null]
var temp_slot: Node = null
var swap_position: int = 0 #0 is null, 1 is slot 1 and so on.

var biped: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	biped = get_parent()
	inventory.resize(30) #makes the inventory 30 slots 

func _process(delta: float) -> void:
	pass
	#print(stow_slots)

func drop_weapon():
	if equipped != null:
		equipped.changeOwnership(biped, false)
		equipped = null

#func weapon_switch_handler():
	##variation for stowing weapon, pulling out other weapon.
	
	#if equipped != null:
		#if Input.is_action_just_pressed("slot1"):
			#if slot1 == null:
				#slot1 = equipped
				#equipped = null
			#else:
				#temp_slot = slot1
				#slot1 = equipped
				#equipped = temp_slot
				#temp_slot = null
		#if Input.is_action_just_pressed("slot2"):
			#if slot2 == null:
				#slot2 = equipped
				#equipped = null
			#else:
				#temp_slot = slot2
				#slot2 = equipped
				#equipped = temp_slot
				#temp_slot = null
	#else:
		#pass
	
	#if biped.inventory.equipped != null:
		#var temp_store
		#

#SLOT INVENTORY

#func obtain(equipment_node):
	#equipment_node.reparent(self)
#
#func drop(equipment_node):
	#equipment_node.reparent(GAME.WORLD.ITEMS)
#GRID INVENTORY

func add_item():
	update_inventory_UI() #function that update the inventory screen
	pass

func remove_item():
	update_inventory_UI() #function that update the inventory screen
	pass

func increase_inventory_size():
	update_inventory_UI() #function that update the inventory screen
	pass

func update_inventory_UI():
	pass
