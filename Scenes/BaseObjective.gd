class_name BaseObjective
extends Node

@export var _objective_description: String

var _objective_complete = false

func update_ui(): # update the objectives list to show the objective is done
	pass

func update_world(): #change things in the world. Mainly starting animations or hiding and making visible different objects
	pass

func get_objective_description():
	return _objective_description

#below might change from objective to objective
