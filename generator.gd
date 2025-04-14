extends Node3D

@export var power_grid: String
@export var power_state: bool = true
# Called when the node enters the scene tree for the first time.

func init():
	set_power(power_state)

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GAME.WORLD.loaded:
		init()
	
	if interact_cooldown > 0:
		interact_cooldown -= delta

func set_power(onoff: bool):
	for i in GAME.WORLD.POWERED:
		if i.power_grid == power_grid:
			i.stats.is_powered = onoff
	

var interact_cooldown: float = 0
var interact_cooldown_time: float = 1
func interact(entity):
	if interact_cooldown <= 0:
		print("test")
		power_state = !power_state
		set_power(power_state)
		interact_cooldown = interact_cooldown_time
