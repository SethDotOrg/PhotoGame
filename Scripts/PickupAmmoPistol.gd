extends PickupBase

func _on_area_entered(area):
	print("AMMO GIVEN TO ", area)
	area.add_package()
	self.get_parent().get_parent().queue_free()
