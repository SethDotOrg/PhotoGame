extends Node

#TODO switch the global variable to just the objectives for the level. Otherwise the scenes load

enum {PROTOTYPE, CARGO}
var _current_level: int
#add more levels as they are made

var _in_handheld_camera: bool

var _sewer_pickup_count: int

func _ready():
	#for now we will just start at the cargo level
	set_curr_level(CARGO)

func get_curr_level_objectives():
	if _current_level == CARGO:
		return CargoYardLevelObjectives
func set_curr_level(level_selected):
	_current_level = level_selected 

func check_sewer_pickup_count():
	if _sewer_pickup_count >= 5:
		CargoYardLevelObjectives.get_objective_node(8)._objective_complete = true#sewer monster objective position is 8
