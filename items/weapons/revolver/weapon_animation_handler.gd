extends AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire():
	set("parameters/fire_set/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func reload():
	set("parameters/reload_set/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	print("RELOAD ANIMATION")
	

func set_animation_speed(animation: String, speed: float):
	#set the speed in seconds.
	if animation == "firing":
		set("parameters/fire_scale/scale", 1/speed)
	elif animation == "stow":
		set("parameters/stow_scale/scale", 1/speed)
		print(1/speed)
	elif animation == "draw":
		set("parameters/draw_scale/scale", 2/speed)
	elif animation == "reload":
		set("parameters/reload_scale/scale", 1/speed)
		#print("1/speed" + str(1/speed))


func set_draw(yesno: bool):
	print(str(yesno) + ", draw")
	set("parameters/draw_set/blend_amount", yesno)

func set_stow(yesno: bool):
	print(str(yesno) + ", draw")
	set("parameters/stow_set/blend_amount", yesno)
