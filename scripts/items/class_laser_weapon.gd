extends weapon_gun
class_name energy_gun

var battery = 100
var heat: float
var heat_disipation: float = 5

func _ready() -> void:
	base_item_ready()
	weapon_ready()

func _process(delta: float) -> void:
	#process_muzzle_flash(delta)
	manage_heat(delta)


func manage_heat(delta: float):
	if heat > 0:
		heat -= delta * heat_disipation
	elif heat >= 100:
		#trigger overheat state in torso
		print("overheat!")
		#biped.torso_handler.current_state.transition_to_state("torso_overheat")

func primary_fire():
	if heat > 100:
		biped.torso_handler.current_state.transition_to_state("torso_overheat")
	elif battery >= 0:
		biped.torso_handler.current_state.transition_to_state("torso_firing")
	else:
		biped.torso_handler.current_state.transition_to_state("torso_reload")
	

func secondary_fire():
	pass
