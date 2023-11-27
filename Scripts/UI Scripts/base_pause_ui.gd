class_name Base_Pause_UI
extends Control

@onready var _resume_button = $BoxContainer/ResumeButton
@onready var _options_button = $BoxContainer/OptionsButton
@onready var _quit_button = $BoxContainer/QuitButton
@onready var _player_ui = get_parent().get_parent()

func _on_resume_button_button_down():
	get_parent().handle_game_resume()

func _on_options_button_button_down():
	visible = false
	get_parent().get_node("OptionsUI").visible = true
	_player_ui.current_state = _player_ui.MENU_STATES.OPTIONS_STATE

func _on_quit_button_button_down():
	get_tree().quit()

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel") and _player_ui.current_state == _player_ui.MENU_STATES.PAUSE_STATE:
		get_parent().handle_game_resume()
