extends State

@export var fall_state: State
@export var jump_state: State
@export var idle_state: State
@export var walk_state:State
@export var run_state: State
@export var crouch_walk_state: State
@export var climb_mantle_state: State
@export var stairs_state: State
@export var _camera_walk_state: State

func enter() -> void:
	super()
	number_of_wall_jumps = 0
	tried_mantle = false

func process_input(event: InputEvent) -> State:
	super(event)
	if parent.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			return jump_state
		if parent.velocity.x != 0 and parent.velocity.z != 0 and Input.is_action_pressed("run"):#if the player is moving and pressing the run button
			return run_state
		if Input.is_action_pressed("ctrl"):
			return _camera_walk_state
	if Input.is_action_just_pressed("crouch"):
		return crouch_walk_state
	if Input.is_action_pressed("mouse_right") and parent.mantle_checks():#should be on the ground so mantle 
		return climb_mantle_state
	return null

func process_physics(delta: float) -> State:
	super(delta)
	speed = parent.WALK_SPEED #if we are in this state then we should be using the walk speed
	parent.velocity.y -= (gravity * 2) * delta #apply gravity to the player while they are walking
	direction = parent._camera_controller.get_direction_from_mouse(direction)
	
	#move player toward the direction value and rotate the model
	if direction:
		parent.velocity.x = -direction.x * speed #we get the amount of direction in the x direction and apply speed to it. Speed allows us to not be super slow
		parent.velocity.z = -direction.z * speed #same but in the z direction
		parent._model.rotation.y = lerp_angle(parent._model.rotation.y, atan2(parent.velocity.x, parent.velocity.z), parent.LERP_VAL) # we rotate the model to match direction, but we dont do it instantaineous
	else:
		parent.velocity.x = move_toward(-parent.velocity.x, 0, speed) #else we bring the player to a
		parent.velocity.z = move_toward(-parent.velocity.z, 0, speed) #gradual stop horizontally
	parent.move_and_slide()
	
	if parent.is_on_floor() and parent.velocity.x == 0 and parent.velocity.z == 0:#if on the floor and not horizontally moving
		return idle_state
	if parent.velocity.x != 0 and parent.velocity.z != 0:
		return walk_state
	if parent.velocity.y < 0: #if the players y axis velocity is less than 0 then the player is falling
		return fall_state
	if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor(): #if the stairs checks pass and the player is on the floor
		return stairs_state
	
	return null
	
