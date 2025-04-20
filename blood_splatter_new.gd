extends Node3D

var gravity = 9.8
var reset: bool
var velocity: Vector3 = Vector3(0, 0, 0)
var blood_decal
var make_blood: bool = true
var has_made_blood: bool


var blood_ray

var starting_vel: Vector3
var starting_pos: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = starting_pos
	velocity = starting_vel
	blood_ray = $blood_ray
	blood_ray.target_position = Vector3(0, 0, 0)
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	print("blood vel: " + str(velocity))
	
	print("colliding at: " + str(blood_ray.get_collision_point()))
	velocity.y += -gravity * delta
	global_position += velocity
	blood_ray.target_position = velocity
	if blood_ray.is_colliding():
		if make_blood:
			blood_decal = load("res://blood_decal.tscn").instantiate()
			blood_decal.name = "blood_spot"
			blood_decal.norm = blood_ray.get_collision_normal()
			GAME.WORLD.SCENERY.add_child(blood_decal)
			blood_decal.global_position = blood_ray.get_collision_point()
			blood_decal.rotation.y = randf() * deg_to_rad(360)
			has_made_blood = true
		queue_free()
