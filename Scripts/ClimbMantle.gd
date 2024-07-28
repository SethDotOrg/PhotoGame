extends State

@export var idle_state: State

func process_physics(delta: float) -> State:
	#handle mantle
	parent._mantle_ray_forward_center.add_exception(parent)
	parent._mantle_ray_forward_center_higher.add_exception(parent)
	if parent._mantle_ray_check_center.is_colliding() and !parent._mantle_air_ray_center.is_colliding():
		parent.velocity = Vector3.ZERO
		parent._mantle_ray_forward_center.global_position.y = parent._mantle_ray_check_center.get_collision_point().y
		if !parent._mantle_ray_forward_center_higher.is_colliding():
			parent.global_position = parent._mantle_ray_check_center.get_collision_point()
			return idle_state
		else:
			return idle_state
	elif parent._mantle_ray_check_left.is_colliding() and !parent._mantle_air_ray_left.is_colliding():
		parent.velocity = Vector3.ZERO
		parent._mantle_ray_forward_center.global_position.y = parent._mantle_ray_check_left.get_collision_point().y
		if !parent._mantle_ray_forward_center_higher.is_colliding():
			parent.global_position = parent._mantle_ray_check_left.get_collision_point()
			return idle_state
		else:
			return idle_state
	elif parent._mantle_ray_check_right.is_colliding() and !parent._mantle_air_ray_right.is_colliding():
		parent.velocity = Vector3.ZERO
		parent._mantle_ray_forward_center.global_position.y = parent._mantle_ray_check_right.get_collision_point().y
		if !parent._mantle_ray_forward_center_higher.is_colliding():
			parent.global_position = parent._mantle_ray_check_right.get_collision_point()
			return idle_state
		else:
			return idle_state
	return null
