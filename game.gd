############GAME MANAGER CODE
extends Node
 
var eligibleSoundScapes = []
var currentSoundScape : Node3D

var player
var WORLD #The node that holds the level.

func _ready() -> void:
	WORLD = $"."
	player = WORLD.player
 
func _physics_process(delta: float) -> void:
	soundscape(delta)

func soundscape(delta):
	if eligibleSoundScapes.size() > 0:
		var d = []
		for x in range(eligibleSoundScapes.size()-1):
			if eligibleSoundScapes[x].distanceToPlayer:
				var a = eligibleSoundScapes[x].distanceToPlayer
				d.append(a)
		d.sort()
		for i in range(d.size()-1):
			if d[0] == eligibleSoundScapes[i].distanceToPlayer:
				currentSoundScape = eligibleSoundScapes[i]
