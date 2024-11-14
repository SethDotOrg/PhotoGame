extends Node3D

@onready var manhole_open = $Manhole/ManholeOpenCollection
@onready var manhole_closed = $Manhole/ManholeClosedCollection

#will need to access the right array pos(is it easier to do it manually. It shouldnt change right?)
func secret_crane_update():
	CargoYardLevelObjectives._objectives[0]._objective_complete = true
	print("objective complete secret crane==== ",CargoYardLevelObjectives._objectives[0]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())
func _on_secret_crane_area_3d_area_entered(area):
	secret_crane_update()
func cement_pole_update():
	CargoYardLevelObjectives._objectives[1]._objective_complete = true
	print("objective complete cement pole==== ",CargoYardLevelObjectives._objectives[1]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())
func seagull_update():
	CargoYardLevelObjectives._objectives[2]._objective_complete = true
	print("objective complete seagull==== ",CargoYardLevelObjectives._objectives[2]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())
func crane_sit_update():
	CargoYardLevelObjectives._objectives[3]._objective_complete = true
	print("objective complete crane sit==== ",CargoYardLevelObjectives._objectives[3]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())
func sugarpile_update():
	CargoYardLevelObjectives._objectives[4]._objective_complete = true
	print("objective complete sugarpile==== ",CargoYardLevelObjectives._objectives[4]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())
func hard_hat_update():
	CargoYardLevelObjectives._objectives[5]._objective_complete = true
	print("objective complete hard hat==== ",CargoYardLevelObjectives._objectives[5]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())
func hotdog_update():
	CargoYardLevelObjectives._objectives[6]._objective_complete = true
	print("objective complete hotdog==== ",CargoYardLevelObjectives._objectives[6]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())
	get_parent().get_player_node().unhide_hotdog()
func boots_update():
	CargoYardLevelObjectives._objectives[7]._objective_complete = true
	print("objective complete boots==== ",CargoYardLevelObjectives._objectives[7]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())
func sewer_monster_update():
	CargoYardLevelObjectives._objectives[8]._objective_complete = true
	print("objective complete sewer monster==== ",CargoYardLevelObjectives._objectives[8]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())
	manhole_open.visible = true
	manhole_closed.visible = false
func cone_siloam_update():
	CargoYardLevelObjectives._objectives[9]._objective_complete = true
	print("objective complete cone siloam==== ",CargoYardLevelObjectives._objectives[9]._objective_complete)
	CargoYardLevelObjectives.update_objectives(get_parent().get_player_node().get_live_ui())


