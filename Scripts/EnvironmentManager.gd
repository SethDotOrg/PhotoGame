extends Node3D

@onready var _objective_marker = $ObjectiveCheckMarker

# Called when the node enters the scene tree for the first time.
func _ready():
	_objective_marker.start_animation()
