extends BaseUI

@export var further_options_ui: Further_Options_UI

#camera controller is in base script
var curr_dof
var config = ConfigFile.new()
var err

#func constructor():
	#_player_ui = further_options_ui.get_player_ui()

func _ready():
	#	#constructor()
	# Load data from a file.
	#err = config.load("user://options.ini")
	err = config.load("user://options.ini")
	
	# If the file didn't load, ignore it.
	if err != OK:
		print("file didnt load")
	
	# Iterate over all sections.
	#for gfx_option in config.get_sections():
		# Fetch the data for graphics options.
	var file_screen_type = config.get_value("Graphic_Options","DOF","false")
		
	#print("file screen type----",file_screen_type)
	curr_dof = file_screen_type
	#print("curr screen type----",curr_screen_type)
	
	if(curr_dof == "true"):
		_camera_controller.toggle_dof(true)
		#print("WF")
	elif(curr_dof == "false"):
		_camera_controller.toggle_dof(false)
		#print("EF")

func get_curr_dof():
	return curr_dof

func _on_toggled(button_pressed):
	if button_pressed == true:
		_camera_controller.toggle_dof(true)
	elif button_pressed == false:
		_camera_controller.toggle_dof(false)
