class_name UI
extends BaseUI

@export var _live_ui:Live_UI
@export var _pause_ui:Pause_UI

var ammo_count
var current_state

enum MENU_STATES {LIVE_STATE, PAUSE_STATE, OPTIONS_STATE, GRAPHICS_OPTIONS_STATE, SOUND_OPTIONS_STATE, CONTROL_OPTIONS_STATE}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_live_ui.visible = true
	_pause_ui.visible = false
	current_state = MENU_STATES.LIVE_STATE

func update_hud_ammo(current_ammo:int, mag_size:int):
	_live_ui.update_hud_ammo(current_ammo, mag_size)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_cancel") and current_state == MENU_STATES.LIVE_STATE:
		await get_tree().create_timer(0.1).timeout #seconds
		current_state = MENU_STATES.PAUSE_STATE
		get_tree().paused = true
		_live_ui.visible = false
		_pause_ui.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_pressed("mouse_right") and current_state == MENU_STATES.LIVE_STATE:
		_live_ui.toggle_reticle(true)
	else:
		_live_ui.toggle_reticle(false)

func handle_game_resume():
	await get_tree().create_timer(0.1).timeout #seconds
	current_state = MENU_STATES.LIVE_STATE
	get_tree().paused = false
	_live_ui.visible = true
	_pause_ui.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_live_ui():
	return get_child(0)
