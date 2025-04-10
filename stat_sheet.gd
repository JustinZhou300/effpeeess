extends Resource
class_name stat_sheet

@export var name: String = ""
@export var description:String = ""

@export var team: int = 1
@export var mass: float = 70.0

@export var strength: int = 0
@export var endurance: int = 0
@export var dexterity: int = 0
@export var agility: int = 0
@export var intelligence: int = 0
@export var mind: int = 0
@export var luck: int = 0

#resistences correspond to 4 elements (kinetic, thermal, shock, holy)
@export var kinetic_resistance: float
@export var thermal_resistance: float
@export var shock_resistance: float
@export var holy_resistance: float
