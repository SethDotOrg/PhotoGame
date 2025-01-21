extends Node

#TODO switch the global variable to just the objectives for the level. Otherwise the scenes load

enum {PROTOTYPE, CARGO}
var _current_level: int
#add more levels as they are made

var _in_handheld_camera: bool
var _in_sit_area: bool
var _jogging: bool = false
var _number_of_wall_jumps: int

var _sewer_pickup_count: int
var _hotdog_pickup_count: int

var _sitting_point: Node3D
var _return_point: Node3D

func _ready():
	#for now we will just start at the cargo level
	set_curr_level(CARGO)

func get_curr_level_objectives():
	if _current_level == CARGO:
		return CargoYardLevelObjectives
func set_curr_level(level_selected):
	_current_level = level_selected 

func check_hotdog_pickup_count():
	if _hotdog_pickup_count >= 4:
		CargoYardLevelObjectives.get_objective_node(6)._objective_complete = true#hotdog objective position is 6
func check_sewer_pickup_count():
	if _sewer_pickup_count >= 5:
		CargoYardLevelObjectives.get_objective_node(8)._objective_complete = true#sewer monster objective position is 8
