extends State

@export var idle_state: State

func enter() -> void:
	super()

func process_physics(delta: float) -> State:	#TODO finish climb. need to set transition from other states
	#Handle Climb
	parent._climbing_ray_position_check.add_exception(parent)
	parent._climbing_ray_geo_check_knee.add_exception(parent)
	
	if parent._climbing_ray_position_check.is_colliding() and !parent._air_ray_center.is_colliding():
		parent.velocity = Vector3.ZERO
		parent.set_process_input(false)
		#await get_tree().create_timer(0.2).timeout#seconds
		parent.set_process_input(true)
		parent.global_position = parent._climbing_ray_position_check.get_collision_point()
		return idle_state
	elif parent._climbing_ray_position_check_left.is_colliding() and !parent._air_ray_left.is_colliding():
		parent.velocity = Vector3.ZERO
		parent.set_process_input(false)
		#await get_tree().create_timer(0.2).timeout#seconds
		parent.set_process_input(true)
		parent.global_position = parent._climbing_ray_position_check_left.get_collision_point()
		return idle_state
	elif parent._climbing_ray_position_check_right.is_colliding() and !parent._air_ray_right.is_colliding():
		parent.velocity = Vector3.ZERO
		parent.set_process_input(false)
		#await get_tree().create_timer(0.2).timeout#seconds
		parent.set_process_input(true)
		parent.global_position = parent._climbing_ray_position_check_right.get_collision_point()
		return idle_state
	else:
		parent.velocity = Vector3.ZERO
		return idle_state
	return null
