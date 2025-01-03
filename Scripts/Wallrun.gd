extends State


#TODO NEED TO EDIT FOR WALLRUN INSTEAD OF WALLJUMP

const MAX_WALLJUMPS = 3

@export var _wall_run_up_timer: Timer
@export var _wallrun_to_walljump_up_timer: Timer
 
@export var idle_state: State
@export var jump_state: State
@export var fall_state: State
@export var wall_jump_state: State

var walljump_increased = false

#var jump_pressed = true

func enter():
	#jump_pressed = true #we should be holding down jump when we enter this state so keep track of that when we enter the state
	_wall_run_up_timer.start()
	_wallrun_to_walljump_up_timer.start()
	walljump_increased = false
	

#func process_input(event: InputEvent) -> State:
	#if Input.is_action_just_released("jump"):
		#jump_pressed = false
	#return null

func process_physics(delta: float) -> State:
	
	if _wall_run_up_timer.time_left > 0:
		parent.velocity.y = 0
		parent._camera_controller.follow_target(parent._camera_point_shoulder, delta)
		parent.move_and_slide()  
	elif _wall_run_up_timer.time_left <= 0:
		#parent.velocity.y = -4 # transition from -2 to a lower negative value
		parent.velocity.y = 0
		parent._camera_controller.follow_target(parent._camera_point_shoulder, delta)
		parent.move_and_slide()   
	
	if !parent.is_on_wall_only():
		return fall_state
	
	#if parent.is_on_wall_only() and Input.is_action_just_pressed("jump"):
		##parent.velocity.y = 15
		#parent.velocity.y = 25            GOOD IF WANT TO JUMP STRAIGHT OUT OF WALLRUN
		#return jump_state
	
	if _wallrun_to_walljump_up_timer.time_left <= 0 and walljump_increased == false:
		GlobalVariables._number_of_wall_jumps += 1
		_base_ui.get_player_ui().get_live_ui().set_walljump_count_text(str(GlobalVariables._number_of_wall_jumps))
		walljump_increased = true
	
	if parent.is_on_wall_only() and Input.is_action_pressed("jump"):
		return wall_jump_state
	
	if parent.is_on_floor():
		return idle_state
	
	return null

