extends State

@export var idle_state: State
@export var jump_state: State
@export var fall_state: State
@export var walk_state: State
@export var run_state: State

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	# I dont think this is needed. But incase there i camera glitches then maybe this will help
	#direction = parent._camera_controller.get_direction_from_mouse(direction)
	
	#Handle Climb
	parent._climbing_ray_position_check.add_exception(parent)
	parent._climbing_ray_geo_check_knee.add_exception(parent)
	
	if parent._climbing_ray_position_check.is_colliding() and !parent._air_ray_center.is_colliding():
		parent.velocity = Vector3.ZERO
		#parent.set_process_input(false)
		#await get_tree().create_timer(0.2).timeout#seconds
		#parent.set_process_input(true)
		parent.global_position = parent._climbing_ray_position_check.get_collision_point()
		print("center")
		return idle_state
	elif parent._climbing_ray_position_check_left.is_colliding() and !parent._air_ray_left.is_colliding():
		parent.velocity = Vector3.ZERO
		#parent.set_process_input(false)
		#await get_tree().create_timer(0.2).timeout#seconds
		#parent.set_process_input(true)
		parent.global_position = parent._climbing_ray_position_check_left.get_collision_point()
		print("left")
		return idle_state
	elif parent._climbing_ray_position_check_right.is_colliding() and !parent._air_ray_right.is_colliding():
		parent.velocity = Vector3.ZERO
		#parent.set_process_input(false)
		#await get_tree().create_timer(0.2).timeout#seconds
		#parent.set_process_input(true)
		parent.global_position = parent._climbing_ray_position_check_right.get_collision_point()
		print("right")
		return idle_state
	
	if parent.is_on_floor() and parent.velocity.x == 0 and parent.velocity.z == 0:
		return idle_state
	elif parent.is_on_floor() and (parent.velocity.x != 0 or parent.velocity.z != 0) and Input.is_action_pressed("run"):
		return run_state
	elif parent.is_on_floor() and (parent.velocity.x != 0 or parent.velocity.z != 0):
		return walk_state
	
	if !parent.is_on_floor() and parent.velocity.y <= 0:
		return fall_state
	elif !parent.is_on_floor() and parent.velocity.y > 0:
		return jump_state
	print("HITTING NULL")
	return null
