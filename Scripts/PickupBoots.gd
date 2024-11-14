extends Area3D

func _on_area_entered(area):
	print("Boots entered ", area)
	get_parent().get_parent().get_parent().boots_update()
