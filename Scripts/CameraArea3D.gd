extends Area3D

#this script handles what we want to do when the camera area interacts with the player

#when the camera enters the player we make the player invisible
func _on_area_entered(area):
	#print("This has entered the cameras area:: ", area)
	if area.is_in_group("HideCameraGroup"):
		area.get_model().visible = false

#when the camera leaves the player we make the character visible again
func _on_area_exited(area):
	#print("This has left the cameras area:: ", area)
	if area.is_in_group("HideCameraGroup"):
		area.get_model().visible = true
