extends State

@export var idle_state: State
@export var crouch_state: State
@export var crouch_walk_state: State

func enter():
	number_of_wall_jumps = 0
	tried_mantle = false
	parent._stair_ray_position_check.global_position = parent._stair_ray_geo_check.get_collision_point() #check the lower raycast for a collision and get it
	parent._stair_ray_position_check.position.y = parent._stair_ray_air_check.position.y#set the closer to the player vertical raycast to match its original y value
	parent.global_position = (parent.global_position * Vector3(1,0,1))+(parent._stair_ray_position.get_collision_point() * Vector3(0,1,0)) #use the second vertical...
	# raycast that is farther from the player and teleport the player to it. This raycast changes alongside the closer to player raycast
	parent._player_collision_shape_crouch.disabled = false
	parent._player_collision_shape.disabled = true

func exit() -> void:
	parent._player_collision_shape_crouch.disabled = true
	parent._player_collision_shape.disabled = false

func process_input(event: InputEvent) -> State:
	super(event)
	if Input.is_action_just_pressed("crouch"):
		return idle_state
	return null

func process_physics(delta: float) -> State:
	parent._stair_ray_position_check.global_position = parent._stair_ray_geo_check.get_collision_point() #check the lower raycast for a collision and get it
	parent._stair_ray_position_check.position.y = parent._stair_ray_air_check.position.y#set the closer to the player vertical raycast to match its original y value
	parent.global_position = (parent.global_position * Vector3(1,0,1))+(parent._stair_ray_position.get_collision_point() * Vector3(0,1,0)) #use the second vertical...
	# raycast that is farther from the player and teleport the player to it. This raycast changes alongside the closer to player raycast
	if (parent.velocity.x != 0 or parent.velocity.z != 0): #if the player is moving
		return crouch_walk_state
	elif parent.velocity.x == 0 and parent.velocity.z == 0: #if the player is not moving horizontally
		return crouch_state
	return null
