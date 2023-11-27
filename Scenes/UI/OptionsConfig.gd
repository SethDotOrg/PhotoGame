extends Node


func _on_save_button_button_down():
	# Create new ConfigFile object.
	var config = ConfigFile.new()
	
	# Store some values.
	config.set_value("Sound_Options", "Master_Volume", $"../VBoxContainerSound/MasterVolumeSlider".value)
	config.set_value("Sound_Options", "SFX_Volume", $"../VBoxContainerSound/SoundEffectVolumeSlider".value)
	config.set_value("Sound_Options", "Music_Volume", $"../VBoxContainerSound/MusicVolumeSlider".value)
	
	config.set_value("Graphic_Options","Resolution",$"../VBoxContainerGraphics/ResolutionOptionButton".get_curr_resolution())
	print($"../VBoxContainerGraphics/ResolutionOptionButton".get_curr_resolution())
	config.set_value("Graphic_Options","Screen_Type",$"../VBoxContainerGraphics/ScreenTypeOptionButton".get_curr_screen_type())
	print($"../VBoxContainerGraphics/ScreenTypeOptionButton".get_curr_screen_type())
	
	# Save it to a file (overwrite if already exists).
	#config.save("user://options.ini")
	config.save("res://options.ini")
