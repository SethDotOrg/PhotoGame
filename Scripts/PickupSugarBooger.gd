extends Area3D

func _on_area_entered(area):
	print("Cocaine entered ", area)
	get_parent().get_parent().get_parent().get_parent().sugarpile_update()
