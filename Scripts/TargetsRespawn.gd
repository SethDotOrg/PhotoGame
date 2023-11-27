extends Node3D

func _process(delta):
	var children = get_children()
	for x in children:
		if x.is_in_group("Shootables") and x.is_visible()==false:
			await get_tree().create_timer(0.7).timeout #seconds
			x.show()
			x.use_collision=true
