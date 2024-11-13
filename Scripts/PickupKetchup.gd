extends Area3D

@export var pickup_root: Node3D

func _on_area_entered(area):
	print("Ketchup entered ", area)
	pickup_root.position.y =- 500
	GlobalVariables._hotdog_pickup_count = GlobalVariables._hotdog_pickup_count + 1
	print("hotdog Pickup Count Collected: ",GlobalVariables._hotdog_pickup_count)
	GlobalVariables.check_hotdog_pickup_count()
	if CargoYardLevelObjectives.get_objective_node(6).get_objective_complete() == true: # 6 being the sewer monster objective
		pickup_root.update_objective()

