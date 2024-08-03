extends State

@export var fall_state: State
@export var jump_state: State
@export var walk_state: State
@export var climb_mantle_state: State
@export var camera_state: State
@export var stairs_state: State
@export var crouch_state: State

func enter() -> void:
	super()
	parent.velocity.x = 0
	number_of_wall_jumps = 0
	tried_mantle = false

func process_input(event: InputEvent) -> State:
	if parent.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			return jump_state
		if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_back"): 
			return walk_state
			
	if Input.is_action_pressed("mouse_right") and parent.mantle_checks():#should be on the ground so mantle 
		return climb_mantle_state
	
	if Input.is_action_pressed("ctrl"):
		return camera_state
	
	if Input.is_action_just_pressed("crouch"):
		return crouch_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y -= (gravity * 2) * delta#apply some gravity to the player while idle
	parent.move_and_slide()
	parent._camera_controller.follow_target(parent._camera_point_shoulder, delta)
	if parent.is_on_wall() and parent.velocity.x == 0 and parent.velocity.z == 0 and check_movement():#if on the wall and not moving but trying to move(in other words the player is stuck on a wall
		#nudge the players velocities so that the player rotates
		parent.velocity.y = 0.1
		parent.velocity.z = 0.1#bump the player slightly to get the unstuck
		parent.velocity.x = 0.1
		#check at the same time of the stair checks have hit. In this case we want to use the stairs state
		if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor() and check_movement():
			return stairs_state
		#else we want them to rotate so return the walk state. Basically the character will keep getting stuck and then 
		#nudged until the player moves from the wall or rotates toward the stair enough to climb on top
		return walk_state
		
	if !parent.is_on_floor():
		return fall_state
	
	if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor() and check_movement(): #if on floor and moving and the stairs checks pass
		return stairs_state
	
	return null

func check_movement() -> bool:
	return Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
