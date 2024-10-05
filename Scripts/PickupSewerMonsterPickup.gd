extends Area3D

@export var pickup_root: Node3D

func _on_area_entered(area):
	print("Sewer Monster Pickup entered ", area)
	pickup_root.position.y =- 500
	GlobalVariables._sewer_pickup_count = GlobalVariables._sewer_pickup_count + 1
	print("Sewer Monster Pickup Count Collected: ",GlobalVariables._sewer_pickup_count)
	GlobalVariables.check_sewer_pickup_count()
	if CargoYardLevelObjectives.get_objective_node(8).get_objective_complete() == true: # 8 being the sewer monster objective
		pickup_root.update_objective()
	#if CargoYardLevelObjectives.get_objective_node(8).get_objective_complete() == true:
		#get_node("SewerMonsterV1").visible = true
