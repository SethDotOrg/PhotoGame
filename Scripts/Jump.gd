extends State

@export var fall_state: State
@export var climb_state: State
@export var wall_jump_state: State
@export var _camera_jump_state: State

@export var JUMP_VELOCITY: float = 10.0

#var speed = parent.WALK_SPEED

func enter() -> void:
	super()
	if parent.is_on_floor():
		parent.velocity.y = JUMP_VELOCITY #if the player presses jump as long as the right conditions are met then we want to apply a jump velocity once. It is easy to do this one time when we enter the state
	
	if Input.is_action_pressed("run"):
		speed = parent.RUN_SPEED
	else:
		speed = parent.WALK_SPEED

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("run"):
		speed = parent.RUN_SPEED
	if Input.is_action_pressed("ctrl"):
		return _camera_jump_state
	if Input.is_action_pressed("mouse_right"):
		return climb_state
	return null

func process_physics(delta: float) -> State:
	super(delta)
	parent.velocity.y -= (gravity * 1.5) * delta
	
	direction = parent._camera_controller.get_direction_from_mouse(direction)
	#Handle camera in air
	parent._camera_controller.jump_camera_handler(parent._camera_point_jump, delta)
	
	if !Input.is_action_pressed("run"):
		speed = parent.WALK_SPEED
	
	#move player toward the direction value and rotate the model
	if direction:
		parent.velocity.x = -direction.x * speed #we get the amount of direction in the x direction and apply speed to it. Speed allows us to not be super slow
		parent.velocity.z = -direction.z * speed #same but in the z direction
		parent._model.rotation.y = lerp_angle(parent._model.rotation.y, atan2(-parent.velocity.x, -parent.velocity.z), parent.LERP_VAL) # we rotate the model to match direction, but we dont do it instantaineous
	else:
		parent.velocity.x = move_toward(-parent.velocity.x, 0, speed) #else we bring the player to a
		parent.velocity.z = move_toward(-parent.velocity.z, 0, speed) #gradual stop horizontally
	parent.move_and_slide()
	
	if parent.velocity.y < 0:#if the players velocity is negative then the play is falling
		return fall_state
	
	if parent.is_on_wall_only() and Input.is_action_just_pressed("jump"): #if the player is on the wall and not the floor and they pressed jump
		return wall_jump_state
	
	return null
