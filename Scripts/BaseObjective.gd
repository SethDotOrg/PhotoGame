
extends Node

@export var _objective_description: String

var _objective_complete

func _init():
	_objective_complete = false

func update_world(): #change things in the world. Mainly starting animations or hiding and making visible different objects
	pass

func get_objective_description():
	return _objective_description

func get_objective_complete():
	return _objective_complete
