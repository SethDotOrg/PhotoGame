extends OptionButton

var curr_resolution
var config = ConfigFile.new()
var err

# Called when the node enters the scene tree for the first time.
func _ready():
	add_resolutions()
	#select(2)
	
	# Load data from a file.
	#err = config.load("user://options.ini")
	err = config.load("res://options.ini")
	
	# If the file didn't load, ignore it.
	if err != OK:
		print("file didnt load")
	
	# Iterate over all sections.
	#for gfx_option in config.get_sections():
		# Fetch the data for graphics options.
	var file_resolution = config.get_value("Graphic_Options","Resolution","resolution not set")
		
	print("file resolution----",file_resolution)
	curr_resolution = file_resolution
	print("curr resolution----",file_resolution)
	
	if(curr_resolution == "1152x648"):
		select(0)
		change_resolution("1152x648")
		print("1152x648 ready if")
	elif(curr_resolution == "1366x768"):
		select(1)
		change_resolution("1366x768")
		print("1366x768 ready if")
	elif(curr_resolution == "1920x1080"):
		select(2)
		change_resolution("1920x1080")
		print("1920x1080 ready if")


func add_resolutions():
	add_item("1152x648")
	add_item("1366x768")
	add_item("1920x1080")

func _on_item_selected(index):
	var resolution = self.get_item_text(index)
	curr_resolution = resolution
	change_resolution(curr_resolution)

func change_resolution(resolution:String):
	var resolution_split = resolution.split("x")
	print("made it to change_resolution",resolution_split)
	
	get_tree().root.content_scale_size = Vector2i(int(resolution_split[0]), int(resolution_split[1])) #changes the resolution in any screen type
	DisplayServer.window_set_size(Vector2i(int(resolution_split[0]), int(resolution_split[1]))) #changes the size of the window. but not the resolution
	DisplayServer.window_set_mode(DisplayServer.window_get_mode())

func get_curr_resolution():
	return curr_resolution
