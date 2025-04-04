extends Control

@export var ammo:= 200
@export var stamina := 100

#@onready var healthValue = $%health
@onready var healthBar = $%health_bar
@onready var ammoValue = $%ammo
#@onready var staminaValue = $%stamina

@onready var slot_0_name = $%slot_0_name
@onready var slot_1_name = $%slot_1_name
@onready var slot_2_name = $%slot_2_name

@onready var updates = $HUDUpdate
@onready var overlay = $overlay

@onready var biped = $".."
@onready var crosshair = $Crosshair
@onready var crosshair_shoot = $Crosshair_shoot

@onready var black_screen = $overlay/black_overlay

var health
var item = preload("res://scenes/hud/hud_item.tscn")

func _ready():
	healthBar.max_value = 55
	healthBar.value = 55
	#healthValue.text = str(health)
	ammoValue.text = str(ammo)
	#staminaValue.text = str(stamina)
	black_screen.visible = true

#func _process(delta: float) -> void:
	#reticle_update(delta)
func _physics_process(delta: float) -> void:
	reticle_update(delta)
	updateHUD()
	update_slots()

func _process(delta: float) -> void:
	if black_screen.visible == true and GAME.WORLD.loaded == true:
		black_screen.visible = false

func updateHUD():
	#healthValue.text = str(biped.stats.health_current)
	healthBar.max_value = roundf(biped.stats.health_max)
	healthBar.value = roundf(biped.stats.health_current)
	if biped.inventory.equipped != null:
		ammoValue.text = str(biped.inventory.equipped.current_ammo)
	#staminaValue.text = str(stamina)

func update_slots():
	if biped.inventory.stow_slots[0] != null:
		slot_0_name.text = biped.inventory.stow_slots[0].item_name
	else:
		slot_0_name.text = ""
	
	if biped.inventory.stow_slots[1] != null:
		slot_1_name.text = biped.inventory.stow_slots[1].item_name
	else:
		slot_1_name.text = ""
	
	if biped.inventory.stow_slots[2] != null:
		slot_2_name.text = biped.inventory.stow_slots[2].item_name
	else:
		slot_2_name.text = ""

func addUpdate(qty, text, color):
	var lab = item.instantiate()
	lab.text = str(qty) + " " + text
	lab.set_modulate(color)
	updates.add_child(lab)

func screenGlow(color):
	var tween = get_tree().create_tween()
	tween.tween_property(overlay, "color", color, 0.1)
	tween.tween_property(overlay, "color", Color(1, 0, 0, 0), 0.7)

func gameOver():
	var tween = get_tree().create_tween()
	tween.tween_property(overlay, "color", Color(1, 0, 0, 1), 0.1)
	$Reset.visible = true

func _on_reset_pressed() -> void:
	pass # Replace with function body.

func reticle_update(delta):
	#biped.shoot_ray.position = biped.playerViewCamera.project_ray_origin(crosshair.position)
	if biped.shoot_ray.is_colliding():
		crosshair_shoot.position = biped.playerViewCamera.unproject_position(biped.shoot_ray.get_collision_point())
	else:
		crosshair_shoot.position = Vector2(0, 0)
