extends State

@export var idle_state: State
@export var jump_state: State
@export var fall_state: State
@export var walk_state: State
@export var run_state: State
@export var ledge_hang_state: State

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	# I dont think this is needed. But incase there i camera glitches then maybe this will help
	#direction = parent._camera_controller.get_direction_from_mouse(direction)
	
	#Handle Climb
	parent._climbing_ray_position_check.add_exception(parent) #exclude the player from getting collided with
	
	#check the climbing points for collision on the vertical raycasts. but not the horizontal
	if parent._climbing_ray_position_check.is_colliding() and !parent._air_ray_center.is_colliding():
		parent.velocity = Vector3.ZERO
		#parent.set_process_input(false)
		#await get_tree().create_timer(0.2).timeout#seconds
		#parent.set_process_input(true)
		var ledge_point = parent._climbing_ray_position_check.get_collision_point() #get the collision of the ray
		var ledge_y = ledge_point.y-parent._ledge_anchor.position.y #since the position of the player is at the models feet we want to minus the height from the feet to where we want the player to grab the ledge
		var player_ledge_point = Vector3(parent.global_position.x,ledge_y,parent.global_position.z)#store a variable with the players x and z coords but use the ledges y coord
		parent.global_position = player_ledge_point #bring the player to that mix of coords
		#print("center")
		return ledge_hang_state
	elif parent._climbing_ray_position_check_left.is_colliding() and !parent._air_ray_left.is_colliding() and parent._climbing_ray_forward_center_lower.is_colliding():
		parent.velocity = Vector3.ZERO
		#parent.set_process_input(false)
		#await get_tree().create_timer(0.2).timeout#seconds
		#parent.set_process_input(true)
		var ledge_point = parent._climbing_ray_position_check_left.get_collision_point() #get the collision of the ray
		var ledge_y = ledge_point.y-parent._ledge_anchor.position.y #since the position of the player is at the models feet we want to minus the height from the feet to where we want the player to grab the ledge
		var player_ledge_point = Vector3(parent.global_position.x,ledge_y,parent.global_position.z)#store a variable with the players x and z coords but use the ledges y coord
		parent.global_position = player_ledge_point #bring the player to that mix of coords
		#print("left")
		return ledge_hang_state
	elif parent._climbing_ray_position_check_right.is_colliding() and !parent._air_ray_right.is_colliding() and parent._climbing_ray_forward_center_lower.is_colliding():
		parent.velocity = Vector3.ZERO
		#parent.set_process_input(false)
		#await get_tree().create_timer(0.2).timeout#seconds
		#parent.set_process_input(true)
		var ledge_point = parent._climbing_ray_position_check_right.get_collision_point() #get the collision of the ray
		var ledge_y = ledge_point.y-parent._ledge_anchor.position.y #since the position of the player is at the models feet we want to minus the height from the feet to where we want the player to grab the ledge
		var player_ledge_point = Vector3(parent.global_position.x,ledge_y,parent.global_position.z)#store a variable with the players x and z coords but use the ledges y coord
		parent.global_position = player_ledge_point #bring the player to that mix of coords
		#print("right")
		return ledge_hang_state
	
	#handle mantle
	if parent._mantle_ray_check_center.is_colliding() and !parent._mantle_air_ray_center.is_colliding():
		parent.velocity = Vector3.ZERO
		parent.global_position = parent._mantle_ray_check_center.get_collision_point()
	if parent._mantle_ray_check_left.is_colliding() and !parent._mantle_air_ray_left.is_colliding():
		parent.velocity = Vector3.ZERO
		parent.global_position = parent._mantle_ray_check_left.get_collision_point()
	if parent._mantle_ray_check_right.is_colliding() and !parent._mantle_air_ray_right.is_colliding():
		parent.velocity = Vector3.ZERO
		parent.global_position = parent._mantle_ray_check_right.get_collision_point()
	
	if parent.is_on_floor() and parent.velocity.x == 0 and parent.velocity.z == 0: #if the player is on the floor and not moving horizontally
		return idle_state
	elif parent.is_on_floor() and (parent.velocity.x != 0 or parent.velocity.z != 0) and Input.is_action_pressed("run"): #if the player is moving and on the floor and pressing the run button
		return run_state
	elif parent.is_on_floor() and (parent.velocity.x != 0 or parent.velocity.z != 0): #if the player is moving and on the floor
		return walk_state
	
	if !parent.is_on_floor() and parent.velocity.y <= 0: #if not on the floor and velocity is negative then the player is falling
		return fall_state
	elif !parent.is_on_floor() and parent.velocity.y > 0: #if not on the floor and the velocity is positive then the player is jumping
		return jump_state
	return null
