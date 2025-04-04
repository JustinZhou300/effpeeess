########SOUNDSCAPE ENTITY CODE
 
@tool
extends Node3D
 
var audioPlayer : AudioStreamPlayer
var areaTrigger : Area3D
 
var playerTargetNode = null
 
var checkRay = false
var checkCurrentFrame = false
var isInSight = false
 
var distanceToPlayer : float
 
var fadeTween : Tween
 
@export var entProperties : Dictionary = {
	"audioFile" : "",
	"targetVol" : 5.0,
	"fadeInTime" : 0.15,
	"radius" : 10
}

func _func_godot_apply_properties(properties : Dictionary):
	entProperties = properties
	
 
func _ready():
	audioPlayer = AudioStreamPlayer.new()
	audioPlayer.volume_db = -30
	self.add_child(audioPlayer)
	audioPlayer.stream = ResourceLoader.load("res://assets/audio/" + entProperties["audioFile"])
	areaTrigger = Area3D.new()
	self.add_child(areaTrigger)
	var col = CollisionShape3D.new()
	col.shape = SphereShape3D.new()
	col.shape.radius = entProperties["radius"]
	areaTrigger.set_collision_mask_value(2, true)
	areaTrigger.add_child(col)
	areaTrigger.connect("body_entered", entTrigger)
	areaTrigger.connect("body_exited", entLeave)
	
func entTrigger(body):
	if body.is_in_group("PLAYER"):
		checkRay = true
		playerTargetNode = body
		audioPlayer.volume_db = -100
func entLeave(body):
	if body.is_in_group("PLAYER"):
		checkRay = false
		
func checkSight(point):
	checkCurrentFrame = !checkCurrentFrame # alternates checks between frames.
	if !checkCurrentFrame:
		return isInSight
	
	var ST = areaTrigger.get_world_3d().direct_space_state
	var param = PhysicsRayQueryParameters3D.new()
	#param.hit_back_faces = false
	param.collide_with_areas = false
	param.collide_with_bodies = true
	#param.hit_from_inside = true
	param.from = areaTrigger.global_position
	param.to = point.global_position# + areaTrigger.global_position.direction_to(point.global_position)
	param.exclude = [areaTrigger]
	var result = ST.intersect_ray(param)
	if result.has("collider"):
		#print(result.collider)
		if result.collider == point:
			return true
		else:
			return false
	else:
		return false
 
func _physics_process(delta: float) -> void:
	#print(playerTargetNode)
	if playerTargetNode:
		distanceToPlayer = areaTrigger.global_position.distance_to(playerTargetNode.global_position)
		#print('playnodedist: ' +str(distanceToPlayer))
	if audioPlayer.playing:
		if GAME.currentSoundScape != self:
			fadeTween = create_tween()
			fadeTween.tween_property(audioPlayer, "volume_db", -30.0, entProperties["fadeInTime"]).set_trans(Tween.TRANS_LINEAR)
			await fadeTween.finished
			audioPlayer.stream_paused = true
	if checkRay:
		if checkSight(playerTargetNode):
			GAME.eligibleSoundScapes.append(self)
		if GAME.currentSoundScape == self:
			if audioPlayer.stream_paused == true:
				audioPlayer.stream_paused = false
			else:
				if audioPlayer.playing != true:
					audioPlayer.play()
			if audioPlayer.volume_db < entProperties["targetVol"]:
				fadeTween = create_tween()
				fadeTween.tween_property(audioPlayer, "volume_db", entProperties["targetVol"], entProperties["fadeInTime"]).set_trans(Tween.TRANS_LINEAR)
 
