extends State

@export var idle_state: State
@export var walk_state: State
@export var run_state: State
@export var climb_fall_state: State
@export var wall_jump_state: State
@export var _camera_fall_state: State
@export var crouch_state: State

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("run"):
		speed = parent.RUN_SPEED
	if Input.is_action_pressed("ctrl"):
		return _camera_fall_state
	if Input.is_action_pressed("mouse_right") and !parent.is_on_floor():
		return climb_fall_state
	if Input.is_action_just_pressed("crouch"):
		return crouch_state
	return null

func process_physics(delta: float) -> State:
	super(delta)
	parent.velocity.y -= (gravity * 2) * delta #apply gravity to the player when falling. In this case we want more force on the player when falling
	direction = parent._camera_controller.get_direction_from_mouse(direction)
	#Handle camera in air
	parent._camera_controller.jump_camera_handler(parent._camera_point_jump, delta)
	if !Input.is_action_pressed("run"):
		speed = parent.WALK_SPEED
	
	#move player toward the direction value and rotate the model
	if direction:
		parent.velocity.x = -direction.x * speed #we get the amount of direction in the x direction and apply speed to it. Speed allows us to not be super slow
		parent.velocity.z = -direction.z * speed #same but in the z direction
		parent._model.rotation.y = lerp_angle(parent._model.rotation.y, atan2(parent.velocity.x, parent.velocity.z), parent.LERP_VAL) # we rotate the model to match direction, but we dont do it instantaineous
	else:
		parent.velocity.x = move_toward(-parent.velocity.x, 0, speed) #else we bring the player to a..
		parent.velocity.z = move_toward(-parent.velocity.z, 0, speed) #gradual stop horizontally
	parent.move_and_slide()
	
	if parent.is_on_wall_only() and Input.is_action_just_pressed("jump"):#if on the wall and not on the floor and the player presses jump
		return wall_jump_state
	
	if parent.is_on_floor():
		if parent.velocity.x != 0 and parent.velocity.z != 0 and parent.is_on_floor() and Input.is_action_pressed("run"): #if moving on the floor and pressing the run button
			return run_state
		elif parent.velocity.x != 0 and parent.velocity.z != 0 and parent.is_on_floor(): #if moving on the floor
			return walk_state
		return idle_state
	return null
