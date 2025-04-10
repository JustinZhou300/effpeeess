extends GPUParticles3D

var timer
var spawn_position
var blood_direction
var blood_decal
@export var make_blood: bool
var has_made_blood

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = 0
	emitting = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	
	if timer >= 0.7 * lifetime and !has_made_blood:
		if make_blood:
			blood_decal = load("res://blood_decal.tscn").instantiate()
			GAME.WORLD.SCENERY.add_child(blood_decal)
			blood_decal.global_position = global_position
			blood_decal.rotation.y = randf() * deg_to_rad(360)
			has_made_blood = true
	
	if timer >= lifetime:
		queue_free()
