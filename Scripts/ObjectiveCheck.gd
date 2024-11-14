class_name Objective_Check_Marker
extends Area3D

func _on_area_entered(area):
	print("Objective entered ", area)
	if area.get_pickup_count() == 3:
		area.get_live_ui().display_text_message("YOU COMPLETED ALL OF THE OBJECTIVES!")
		print("YOU COMPLETED ALL OF THE OBJECTIVES!")
	else:
		area.get_live_ui().display_text_message("You need more packages")
		print("You need more packages")
