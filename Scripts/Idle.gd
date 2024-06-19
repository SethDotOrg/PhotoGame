extends State

@export var fall_state: State
@export var jump_state: State
@export var walk_state: State
@export var climb_state: State
@export var camera_state: State

func enter() -> void:
	super()
	parent.velocity.x = 0
	number_of_wall_jumps = 0

func process_input(event: InputEvent) -> State:
	if parent.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			return jump_state
		if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_back"): 
			return walk_state
			
	if Input.is_action_pressed("mouse_right"):
		return climb_state
	
	if Input.is_action_pressed("ctrl"):
		return camera_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y -= (gravity * 2) * delta
	parent.move_and_slide()
	
	parent._camera_controller.follow_target(parent._camera_point_shoulder, delta)
	
	if !parent.is_on_floor():
		return fall_state
	return null
