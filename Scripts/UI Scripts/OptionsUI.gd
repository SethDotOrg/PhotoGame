class_name Options_UI
extends Control

@onready var _player_ui = get_parent().get_parent()
@onready var _pause_ui = get_parent()

func _on_back_button_button_down():
	handle_return_to_base_pause_menu()

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel") and _player_ui.current_state == _player_ui.MENU_STATES.OPTIONS_STATE:
		handle_return_to_base_pause_menu()
		

func handle_return_to_base_pause_menu():
	await get_tree().create_timer(0.1).timeout #seconds
	_player_ui.current_state = _player_ui.MENU_STATES.PAUSE_STATE
	_pause_ui.get_node("BasePauseUI").visible = true
	visible = false

func _on_graphics_options_button_button_up():
	await get_tree().create_timer(0.1).timeout #seconds
	_player_ui.current_state = _player_ui.MENU_STATES.GRAPHICS_OPTIONS_STATE
	visible = false
	_pause_ui.get_node("Further_Options_UI").visible = true
	_pause_ui.get_node("Further_Options_UI").get_node("VBoxContainerGraphics").visible = true
	_pause_ui.get_node("Further_Options_UI").get_node("VBoxContainerSound").visible = false
	_pause_ui.get_node("Further_Options_UI").get_node("VBoxContainerControl").visible = false

func _on_sound_options_button_button_up():
	await get_tree().create_timer(0.1).timeout #seconds
	_player_ui.current_state = _player_ui.MENU_STATES.SOUND_OPTIONS_STATE
	visible = false
	_pause_ui.get_node("Further_Options_UI").visible = true
	_pause_ui.get_node("Further_Options_UI").get_node("VBoxContainerGraphics").visible = false
	_pause_ui.get_node("Further_Options_UI").get_node("VBoxContainerSound").visible = true
	_pause_ui.get_node("Further_Options_UI").get_node("VBoxContainerControl").visible = false


func _on_control_options_button_button_up():
	await get_tree().create_timer(0.1).timeout #seconds
	_player_ui.current_state = _player_ui.MENU_STATES.CONTROL_OPTIONS_STATE
	visible = false
	_pause_ui.get_node("Further_Options_UI").visible = true
	_pause_ui.get_node("Further_Options_UI").get_node("VBoxContainerGraphics").visible = false
	_pause_ui.get_node("Further_Options_UI").get_node("VBoxContainerSound").visible = false
	_pause_ui.get_node("Further_Options_UI").get_node("VBoxContainerControl").visible = true
