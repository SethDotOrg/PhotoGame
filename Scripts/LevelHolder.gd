extends Node3D


func get_player_node():
	return get_parent().get_node("PlayerHolder").get_player_node()

func get_player_holder_node():
	return get_parent().get_node("PlayerHolder")
