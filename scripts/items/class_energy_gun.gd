extends weapon_gun
class_name energy_gun

var battery = 100
var heat: float
@export var heat_disipation: float = 5
@export var battery_usage: float = 5
var venting: bool
@export var heat_amount: float
var current_overheat_effect
@export var overheat_effect:GPUParticles3D
@export var overheat_effect_pos: Node3D

func _ready() -> void:
	super()
	if overheat_effect == null:
		overheat_effect = preload("res://effects/overheat.tscn").instantiate()
	overheat_effect.position = overheat_effect_pos.position
	add_child(overheat_effect)
	overheat_effect.emitting = false
	

func _process(delta: float) -> void:
	#process_muzzle_flash(delta)
	manage_heat(delta)


func manage_heat(delta: float):
	if heat > 0 and venting:
		heat -= delta * heat_disipation * 2
	elif heat > 0:
		heat -= delta * heat_disipation

func primary_fire():
	heat += heat_amount
	if heat > 100:
		biped.torso_handler.current_state.transition_to_state("torso_overheat")
	elif battery >= 0:
		biped.torso_handler.current_state.transition_to_state("torso_firing")
	else:
		#MAKE IT CLICK TO SIGNIFY EMPTY
		pass
	

func fire():
	shoot_hitscan()
	battery -= battery_usage

func secondary_fire():
	pass

func proc_reload():
	if heat > 0: 
		biped.torso_handler.current_state.transition_to_state("torso_overheat")
