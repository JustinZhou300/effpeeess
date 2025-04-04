extends Node3D

var groundCast: RayCast3D
var groundCheck: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	groundCast = RayCast3D.new()
	add_child(groundCast)
	groundCast.global_position = global_position
	groundCast.target_position = Vector3(0, -10, 0)
	groundCast.set_collision_mask_value(1, true)
	groundCast.exclude_parent = true
	#exclude = find(self, CollisionShape3D)
	#for child in self.get_children():
		#if is_instance_of(child, CollisionShape3D):
			#
		#elif child.has_children():
			#for grandchild in child.get_children

func find(parent, type):
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
		var grandchild = find(child, type)
		if grandchild != null:
			return grandchild
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("ray_pos = " + str(groundCast.global_position))
	#print("tree_pos = " + str(global_position))
	if groundCast.is_colliding() and !groundCheck:
			print("aligned")
			global_position = groundCast.get_collision_point()
			groundCheck = true
