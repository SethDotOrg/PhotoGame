extends State

@export var idle_state: State
@export var crouch_walk_state: State
@export var crouch_camera_state: State
@export var crouch_stairs_state: State


func enter() -> void:
	super()
	parent.velocity.x = 0
	speed = parent.WALK_SPEED
	number_of_wall_jumps = 0
	tried_mantle = false

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_back"): 
		return crouch_walk_state
	if Input.is_action_pressed("ctrl"):
		return crouch_camera_state
	if Input.is_action_just_pressed("crouch"):
		return idle_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y -= (gravity * 2) * delta#apply some gravity to the player while idle
	#move player toward the direction value and rotate the model
	if direction:
		parent.velocity.x = -direction.x * speed #we get the amount of direction in the x direction and apply speed to it. Speed allows us to not be super slow
		parent.velocity.z = -direction.z * speed #same but in the z direction
		parent._model.rotation.y = lerp_angle(parent._model.rotation.y, atan2(parent.velocity.x, parent.velocity.z), parent.LERP_VAL) # we rotate the model to match direction, but we dont do it instantaineous
	else:
		parent.velocity.x = move_toward(-parent.velocity.x, 0, speed) #else we bring the player to a..
		parent.velocity.z = move_toward(-parent.velocity.z, 0, speed) #gradual stop horizontally
	parent.move_and_slide()
	
	parent._camera_controller.follow_target(parent._camera_point_shoulder, delta)
	if parent.is_on_wall() and parent.velocity.x == 0 and parent.velocity.z == 0 and check_movement():#if on the wall and not moving but trying to move(in other words the player is stuck on a wall
		#nudge the players velocities so that the player rotates
		parent.velocity.y = 0.1
		parent.velocity.z = 0.1#bump the player slightly to get the unstuck
		parent.velocity.x = 0.1
		#check at the same time of the stair checks have hit. In this case we want to use the stairs state
		if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor() and check_movement():
			return crouch_stairs_state
		#else we want them to rotate so return the walk state. Basically the character will keep getting stuck and then 
		#nudged until the player moves from the wall or rotates toward the stair enough to climb on top
		return crouch_walk_state
		
	#if !parent.is_on_floor():
		#return fall_state
	
	if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor() and check_movement(): #if on floor and moving and the stairs checks pass
		return crouch_stairs_state
	
	return null

func check_movement() -> bool:
	return Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
