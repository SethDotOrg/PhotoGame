extends Node

var _current_level: Node3D
#add more levels as they are made

enum {TEST, CARGO}

func _ready():
	#for now we will just start at the cargo level
	_current_level = CargoLevel

func get_curr_level():
	return _current_level

func set_curr_level(level_selected):
	if level_selected == TEST:
		_current_level = TestLevel
	elif level_selected == CARGO:
		_current_level = CargoLevel
