class_name LevelObjectivesBase
extends Node

func get_objective_description(place:int):
	#return the objective description of the node(objective) in place position in the tree
	get_child(place).get_objective_description()
