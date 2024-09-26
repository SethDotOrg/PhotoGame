extends Node3D

#will need to access the right array pos(is it easier to do it manually. It shouldnt change right?)
func secret_crane_update():
	CargoYardLevelObjectives._objectives[0]._objective_complete = true
	print("objective complete secret crane==== ",CargoYardLevelObjectives._objectives[0]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())
func _on_secret_crane_area_3d_area_entered(area):
	secret_crane_update()

func cement_pole_update():
	CargoYardLevelObjectives._objectives[1]._objective_complete = true
	print("objective complete secret crane==== ",CargoYardLevelObjectives._objectives[1]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())
func seagull_update():
	CargoYardLevelObjectives._objectives[2]._objective_complete = true
	print("objective complete secret crane==== ",CargoYardLevelObjectives._objectives[2]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())



