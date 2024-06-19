extends State

@export var fall_state: State
@export var jump_state: State
@export var idle_state: State
@export var walk_state: State
@export var climb_state: State
@export var stairs_state: State
@export var _camera_run_state: State

func enter() -> void:
	super()
	number_of_wall_jumps = 0

func process_input(event: InputEvent) -> State:
	if parent.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			return jump_state
		if parent.velocity.x != 0 and parent.velocity.z != 0 and Input.is_action_just_released("run"):
			return walk_state
	
	if Input.is_action_pressed("ctrl"):
		return _camera_run_state
	
	if Input.is_action_pressed("mouse_right"):
		return climb_state
	return null

func process_physics(delta: float) -> State:
	super(delta)
	speed = parent.RUN_SPEED
	parent.velocity.y -= (gravity * 2) * delta
	direction = parent._camera_controller.get_direction_from_mouse(direction)
	
	#move player toward the direction value and rotate the model
	if direction:
		parent.velocity.x = -direction.x * speed
		parent.velocity.z = -direction.z * speed
		parent._model.rotation.y = lerp_angle(parent._model.rotation.y, atan2(-parent.velocity.x, -parent.velocity.z), parent.LERP_VAL)
	else:
		parent.velocity.x = move_toward(-parent.velocity.x, 0, speed)
		parent.velocity.z = move_toward(-parent.velocity.z, 0, speed)
	parent.move_and_slide()
	
	if parent.is_on_floor() and parent.velocity.x == 0 and parent.velocity.z == 0:
		return idle_state
	if parent.velocity.y < 0:
		return fall_state
	
	if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor():
		return stairs_state
	
	return null
