extends Node3D

@export var _prototype_level: Node3D
@export var _cargo_level: Node3D

func _ready():
	if GlobalVariables._current_level == GlobalVariables.PROTOTYPE:
		_prototype_level.visible = true
		_cargo_level.visible = false
	if GlobalVariables._current_level == GlobalVariables.CARGO:
		_prototype_level.visible = false
		_cargo_level.visible = true

func get_player_node():
	return get_parent().get_node("PlayerHolder").get_player_node()

func get_player_holder_node():
	return get_parent().get_node("PlayerHolder")
