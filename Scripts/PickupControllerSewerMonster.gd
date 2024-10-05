extends Node3D

@onready var sewer_pickup_area_3d = $SewerMonsterPickup1/Area3D

func disable_pickup_collision():
	sewer_pickup_area_3d.monitoring = false

func enable_pickup_collision():
	sewer_pickup_area_3d.monitoring = true

func update_objective():
	get_parent().update_objective()
