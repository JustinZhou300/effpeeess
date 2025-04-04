extends weapon_gun
class_name revolver




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_gun = true
	base_item_ready()
	weapon_ready()
	#current_ammo = 1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#process_muzzle_flash(delta)
	

func fire():
	shoot_hitscan()
	gun_kickback(100)
	current_ammo -= 1
