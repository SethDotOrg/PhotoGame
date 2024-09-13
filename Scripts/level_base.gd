extends Node3D

func get_objective_node():
	return get_node("LevelObjectives")
	
func get_player_node():
	return get_parent().get_player_node()
