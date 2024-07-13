class_name WorldLedgeAnchor
extends Node3D

@onready var _look_at_point = $LookAtPoint

func get_point_to_look_at():
	return _look_at_point.global_position
	
