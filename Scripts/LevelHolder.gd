extends Node3D


func get_player_node():
	return get_parent().get_node("PlayerHolder").get_player_node()
