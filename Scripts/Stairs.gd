extends State

@export var idle_state: State
@export var walk_state: State
@export var run_state: State

func enter():
	number_of_wall_jumps = 0
	parent._stair_ray_position_check.global_position = parent._stair_ray_geo_check.get_collision_point()
	parent._stair_ray_position_check.position.y = parent._stair_ray_air_check.position.y
	parent.global_position = (parent.global_position * Vector3(1,0,1))+(parent._stair_ray_position_check.get_collision_point() * Vector3(0,1,0))
	

func process_physics(delta: float) -> State:
	parent._stair_ray_position_check.global_position = parent._stair_ray_geo_check.get_collision_point()
	parent._stair_ray_position_check.position.y = parent._stair_ray_air_check.position.y
	parent.global_position = (parent.global_position * Vector3(1,0,1))+(parent._stair_ray_position.get_collision_point() * Vector3(0,1,0))
	if (parent.velocity.x != 0 or parent.velocity.z != 0) and Input.is_action_pressed("run"):
		return run_state
	elif (parent.velocity.x != 0 or parent.velocity.z != 0):
		return walk_state
	elif parent.velocity.x == 0 and parent.velocity.z == 0:
		return idle_state
	return null
