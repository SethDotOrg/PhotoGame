extends Node3D

@onready var _objective_marker = $ObjectiveCheckMarker

#this is supposed to manage environment details. We will see if this will be phased out

# Called when the node enters the scene tree for the first time.
func _ready():
	_objective_marker.start_animation()
