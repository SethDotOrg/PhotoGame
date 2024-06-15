extends OptionButton

var curr_screen_type
var config = ConfigFile.new()
var err

func _ready():
	add_screen_types()
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
	var file_screen_type = config.get_value("Graphic_Options","Screen_Type","screen type not set")
		
	#print("file screen type----",file_screen_type)
	curr_screen_type = file_screen_type
	#print("curr screen type----",curr_screen_type)
	
	if(curr_screen_type == "Windowed Fullscreen"):
		select(0)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		#print("WF")
	elif(curr_screen_type == "Exclusive Fullscreen"):
		select(1)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		#print("EF")
	elif(curr_screen_type == "Taskbar Fullscreen"):
		select(2)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		#print("TF")
	elif(curr_screen_type == "Windowed"):
		select(3)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		#print("W")


func add_screen_types():
	add_item("Windowed Fullscreen")
	add_item("Exclusive Fullscreen")
	add_item("Taskbar Fullscreen")
	add_item("Windowed")

func _on_item_selected(index): #has to match the order they are in the menu
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		curr_screen_type = "Windowed Fullscreen"
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		curr_screen_type = "Exclusive Fullscreen"
	elif index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		curr_screen_type = "Taskbar Fullscreen"
	elif index == 3:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		curr_screen_type = "Windowed"

func get_curr_screen_type():
	return curr_screen_type
