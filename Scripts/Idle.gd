extends State

@export var fall_state: State
@export var jump_state: State
@export var walk_state: State
@export var climb_state: State
@export var camera_state: State
@export var stairs_state: State

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
	
	if parent.is_on_wall() and parent.velocity.x == 0 and parent.velocity.z == 0 and check_movement():
		#nudge the players velocities so that the player rotates
		parent.velocity.y = 0.1
		parent.velocity.z = 0.1
		parent.velocity.x = 0.1
		#check at the same time of the stair checks have hit. In this case we want to use the stairs state
		if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor() and check_movement():
			return stairs_state
		#else we want them to rotate so return the walk state. Basically the character will keep getting stuck and then 
		#nudged until the player moves from the wall or rotates toward the stair enough to climb on top
		return walk_state
		
	if !parent.is_on_floor():
		return fall_state
	
	if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor() and check_movement():
		return stairs_state
	
	return null

func check_movement() -> bool:
	return Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
