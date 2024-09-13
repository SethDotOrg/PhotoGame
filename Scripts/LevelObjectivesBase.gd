class_name LevelObjectivesBase
extends Node

@export var _live_UI: Live_UI

var _objectives

func _ready():
	_objectives = get_children()

func get_objective_description(place:int):
	#return the objective description of the node(objective) in place position in the tree
	get_child(place).get_objective_description()

func update_objectives(live_ui: Live_UI):
	#get the node that called parents place in the array of children. Then set the text to have a cross or something
	#to show it is done
	live_ui.update_objectives()
