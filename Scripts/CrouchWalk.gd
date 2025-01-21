extends State

@export var walk_state: State
@export var run_state: State
@export var crouch_state: State
@export var crouch_stairs_state: State
@export var crouch_camera_state: State

func enter() -> void:
	super()
	number_of_wall_jumps = 0
	tried_mantle = false
	parent._player_collision_shape_crouch.disabled = false
	parent._player_collision_shape.disabled = true

func exit() -> void:
	parent._player_collision_shape_crouch.disabled = true
	parent._player_collision_shape.disabled = false

func process_input(event: InputEvent) -> State:
	super(event)
	if Input.is_action_pressed("ctrl"):
		return crouch_camera_state
	if Input.is_action_just_pressed("crouch"):
		parent._crouching_collision_check.enabled = true #enable the raycast for ceiling checks when crouched
		parent._crouching_collision_check.force_raycast_update() #force the raycast update so that we get a good reading no matter the frame
		if !parent._crouching_collision_check.is_colliding():
			if Input.is_action_pressed("run"):
				parent._crouching_collision_check.enabled = false
				return run_state
			else:
				parent._crouching_collision_check.enabled = false
				return walk_state
	return null

func process_physics(delta: float) -> State:
	super(delta)
	parent._camera_controller.crouch_walk_camera_handler(parent._camera_point_crouch_walk, delta)
	parent._animations.play(_animation_name) #need this here so the animation can loop
	speed = parent.WALK_SPEED #if we are in this state then we should be using the walk speed
	direction = parent._camera_controller.get_direction_from_mouse(direction)
	parent.velocity.y -= (gravity * 2) * delta #apply gravity to the player while they are walking
	
	#move player toward the direction value and rotate the model
	if direction:
		parent.velocity.x = -direction.x * speed #we get the amount of direction in the x direction and apply speed to it. Speed allows us to not be super slow
		parent.velocity.z = -direction.z * speed #same but in the z direction
		parent._model.rotation.y = lerp_angle(parent._model.rotation.y, atan2(parent.velocity.x, parent.velocity.z), parent.LERP_VAL) # we rotate the model to match direction, but we dont do it instantaineous
	else:
		parent.velocity.x = move_toward(-parent.velocity.x, 0, speed) #else we bring the player to a
		parent.velocity.z = move_toward(-parent.velocity.z, 0, speed) #gradual stop horizontally
	parent.move_and_slide()
	
	if parent.is_on_floor():
		GlobalVariables._number_of_wall_jumps = 0
	
	if parent.is_on_floor() and parent.velocity.x == 0 and parent.velocity.z == 0:#if on the floor and not horizontally moving
		return crouch_state
	if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor(): #if the stairs checks pass and the player is on the floor
		return crouch_stairs_state
	
	return null
	
