extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready():
	add_resolutions()
	select(2)


func add_resolutions():
	add_item("1152x648")
	add_item("1366x768")
	add_item("1920x1080")

func _on_item_selected(index):
	var resolution = self.get_item_text(index)
	var resolution_split = resolution.split("x")
	print(resolution_split)
	DisplayServer.window_set_size(Vector2i(int(resolution_split[0]), int(resolution_split[1])))
	
	#this just changes screen size. need way to change pixel amount i guess?
