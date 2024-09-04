extends Node

@export var _current_level: Node3D

@export var _test_level: Node3D
@export var _cargoyard_level: Node3D
#add more levels as they are made

enum {TEST, CARGO}

func set_curr_level(level_selected):
	if level_selected == TEST:
		_current_level = _test_level 
	elif level_selected == CARGO:
		_current_level = _cargoyard_level

func get_curr_level_objectives_node():
	_current_level.get_objective_node()
