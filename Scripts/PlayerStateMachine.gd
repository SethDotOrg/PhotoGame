class_name Player_State_Machine
extends Node

@export var _starting_state: State

var current_state: State
var player: Player

# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_state.
func init(parent: Player):
	player = parent
	for child in get_children():
		child.parent = parent

	# Initialize to the default state
	change_state(_starting_state)

# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State):
	if current_state:
		current_state.exit()
	current_state = new_state
	
	var live_ui = player.get_base_ui().get_player_ui().get_live_ui()
	live_ui.update_state_text(new_state.get_state_name())
	print(new_state.get_state_name())
	current_state.enter()
	
# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float):
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent):
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float):
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
