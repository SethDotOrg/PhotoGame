extends Node3D

#will need to access the right array pos(is it easier to do it manually. It shouldnt change right?)
func secret_crane_update():
	CargoYardLevelObjectives._objectives[0]._objective_complete = true
	print("objective complete secret crane==== ",CargoYardLevelObjectives._objectives[0]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())
	

func _on_secret_crane_area_3d_area_entered(area):
	secret_crane_update()
	
#TODO Update the global node of objecives to be able to remember if the task is completed DONE?
# TODO Ask the UI TO UPDATE ++++ GOT IT TO CHANGE TO POOP LOL



