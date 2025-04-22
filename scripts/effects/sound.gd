extends Node3D

var audio_hitbox
var audio_shape

var one_shot: bool
var loud_sound: bool #If not, quiet sound, can't be heard without LoS. If true, can be heard through walls.
var lifetime: float
var time_alive: float
var audio_stream
var set_position: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_hitbox = $audio_hitbox
	audio_shape = $audio_hitbox/audio_shape
	audio_stream = $stream
	if set_position != null:
		global_position = set_position
	lifetime = audio_stream.stream.get_length()
	time_alive = 0
	emit_sound()
	#play sound
	#audio_stream.play()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_alive += delta
	
	if time_alive >= lifetime:
		queue_free()

func emit_sound():
	var hits = audio_hitbox.get_overlapping_bodies()
	#print("we out here")
	for i in hits:
		if i.has(i.stats) == 8:
			if i.stats.is_player:
				#audio_stream.set_stream(sound_file)
				print("PLAYING SOUND CORRECTLY!")
				audio_stream.play()
			else:
				i.alerts.append(global_position)
				print("alert")

#
#
#func physics_update(delta):
	#if entity.view.has_overlapping_bodies():
		#for i in entity.view.get_overlapping_bodies():
			#if !entity.targets.has(i) and i != entity:
				#entity.targets.append(i)
