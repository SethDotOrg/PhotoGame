extends VBoxContainer

@onready var _master_volume_slider = $MasterVolumeSlider 
@onready var _sound_effect_volume_slider = $SoundEffectVolumeSlider 
@onready var _music_volume_slider = $MusicVolumeSlider

var curr_master_volume
var curr_sound_effect_volume
var curr_music_volume
var config = ConfigFile.new()
var err

const sliders_min = 0
const sliders_max = 100
const dB_min = -24
const dB_max = 0

func _ready():
	# Load data from a file.
	#err = config.load("user://options.ini")
	err = config.load("res://options.ini")
	
	# If the file didn't load, ignore it.
	if err != OK:
		print("file didnt load")
	
	# Iterate over all sections.
	#for gfx_option in config.get_sections():
		# Fetch the data for graphics options.
	var file_master_volume = config.get_value("Sound_Options","Master_Volume","master vol not set")
	var file_sound_effect_volume = config.get_value("Sound_Options","SFX_Volume","SFX vol not set")
	var file_music_volume = config.get_value("Sound_Options","Music_Volume","music vol not set")
	
	print("file master----",file_master_volume)
	print("file SFX----",file_sound_effect_volume)
	print("file music----",file_music_volume)
	curr_master_volume = file_master_volume
	curr_sound_effect_volume = file_sound_effect_volume
	curr_music_volume = file_music_volume
	print("curr master----",curr_master_volume)
	print("curr SFX----",curr_sound_effect_volume)
	print("curr music----",curr_music_volume)
	
	var curr_master_volume_dB = (((curr_master_volume - sliders_min) * (dB_max - dB_min)) / (sliders_max - sliders_min)) + dB_min
	AudioServer.set_bus_volume_db(0, curr_master_volume_dB)#master volume
	var curr_sound_effect_volume_dB = (((curr_sound_effect_volume - sliders_min) * (dB_max - dB_min)) / (sliders_max - sliders_min)) + dB_min
	AudioServer.set_bus_volume_db(1, curr_sound_effect_volume_dB)#SFX volume
	var curr_music_volume_dB = (((curr_music_volume - sliders_min) * (dB_max - dB_min)) / (sliders_max - sliders_min)) + dB_min
	AudioServer.set_bus_volume_db(2, curr_music_volume_dB)#music volume
	
	_master_volume_slider.value =\
	(((AudioServer.get_bus_volume_db(0) - dB_min) * (sliders_max - sliders_min)) / (dB_max - dB_min)) + sliders_min
	_sound_effect_volume_slider.value =\
	 (((AudioServer.get_bus_volume_db(1) - dB_min) * (sliders_max - sliders_min)) / (dB_max - dB_min)) + sliders_min
	_music_volume_slider.value =\
	 (((AudioServer.get_bus_volume_db(2) - dB_min) * (sliders_max - sliders_min)) / (dB_max - dB_min)) + sliders_min

func _on_master_volume_slider_drag_ended(value_changed):
	if(get_parent()._player_ui.MENU_STATES.SOUND_OPTIONS_STATE):
		if value_changed == true:
			var slider_value = _master_volume_slider.value
			var new_value = (((slider_value - sliders_min) * (dB_max - dB_min)) / (sliders_max - sliders_min)) + dB_min
			AudioServer.set_bus_volume_db(0, new_value)
			if (slider_value < 0.01):
				AudioServer.set_bus_mute(0, true)
			elif (slider_value >= 0.01):
				AudioServer.set_bus_mute(0, false)

func _on_sound_effect_volume_slider_drag_ended(value_changed):
	if(get_parent()._player_ui.MENU_STATES.SOUND_OPTIONS_STATE):
		if value_changed == true:
			var slider_value = _sound_effect_volume_slider.value
			var new_value = (((slider_value - sliders_min) * (dB_max - dB_min)) / (sliders_max - sliders_min)) + dB_min
			AudioServer.set_bus_volume_db(1, new_value)
			if (slider_value < 0.01):
				AudioServer.set_bus_mute(1, true)
			elif (slider_value >= 0.01):
				AudioServer.set_bus_mute(1, false)

func _on_music_volume_slider_drag_ended(value_changed):
	if(get_parent()._player_ui.MENU_STATES.SOUND_OPTIONS_STATE):
		if value_changed == true:
			var slider_value = _music_volume_slider.value
			var new_value = (((slider_value - sliders_min) * (dB_max - dB_min)) / (sliders_max - sliders_min)) + dB_min
			#AudioServer.set_bus_volume_db(2, linear_to_db(new_value))
			AudioServer.set_bus_volume_db(2, new_value)
			if (slider_value < 0.01):
				AudioServer.set_bus_mute(2, true)
			elif (slider_value >= 0.01):
				AudioServer.set_bus_mute(2, false)
