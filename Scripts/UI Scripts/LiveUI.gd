class_name Live_UI
extends Control


func get_ammo_count_node():
	return $AmmoBackground/AmmoCount

func update_hud_ammo(current_ammo:int, mag_size:int):
	var ammo_count = get_ammo_count_node()
	ammo_count.text = str(current_ammo) + "/" + str(mag_size)

func toggle_reticle(state:bool):
	$Reticle.visible = state
