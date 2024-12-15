extends State


#TODO NEED TO EDIT FOR WALLRUN INSTEAD OF WALLJUMP

const MAX_WALLJUMPS = 3

@export var _wall_jump_timer: Timer
 
@export var jump_state: State
@export var fall_state: State

var jump_pressed = true

func enter():
	jump_pressed = true #we should be holding down jump when we enter this state so keep track of that when we enter the state

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released("jump"):
		jump_pressed = false
	return null

func process_physics(delta: float) -> State:
	#is there a need to count how many wall grabs have happen before touching the ground?
	if _wall_jump_timer.time_left <= 0:
		if jump_pressed == true:
			#parent.velocity=Vector3.ZERO #stop the player from moving in all directions
			parent.velocity.y = -1
			parent.move_and_slide()   #these two lines might be able to be used plus a bigger jump for wallrun
			#need to freeze x and z movement for walljump
			
			#gravity = 0 #stop gravity from acting on the player 	#if _wall_jump_timer.is_stopped() and parent.is_on_wall_only() and jump_pressed == false:
	if _wall_jump_timer.time_left <= 0 and parent.is_on_wall_only() and jump_pressed == false:
		GlobalVariables._number_of_wall_jumps +=1   #MAYBE AFTER 3 OR 4 they become less useful (set to 10) and only keep you around the same height
		if GlobalVariables._number_of_wall_jumps <= MAX_WALLJUMPS:
			parent.velocity.y = 15 #set velocity to the player as a postive value. making them move up
		elif GlobalVariables._number_of_wall_jumps > MAX_WALLJUMPS:
			parent.velocity.y = 10 #this value keeps the player around the same height when wall jumping back and forth
		_wall_jump_timer.start()
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		return jump_state
	if _wall_jump_timer.time_left > 0:
		return fall_state
	return null

