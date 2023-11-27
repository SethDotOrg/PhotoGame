class_name Further_Options_UI
extends Control

@onready var _player_ui = get_parent().get_parent()
@onready var _pause_ui = get_parent()

func _on_back_button_button_down():
	handle_return_to_options_ui()

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel") and (_player_ui.current_state == _player_ui.MENU_STATES.GRAPHICS_OPTIONS_STATE or _player_ui.current_state == _player_ui.MENU_STATES.SOUND_OPTIONS_STATE or _player_ui.current_state == _player_ui.MENU_STATES.CONTROL_OPTIONS_STATE):
		handle_return_to_options_ui()
		

func handle_return_to_options_ui():
	await get_tree().create_timer(0.1).timeout #seconds
	_player_ui.current_state = _player_ui.MENU_STATES.OPTIONS_STATE
	get_parent().get_node("OptionsUI").visible = true
	get_node("VBoxContainerGraphics").visible = false
	get_node("VBoxContainerSound").visible = false
	get_node("VBoxContainerControl").visible = false
	visible = false

