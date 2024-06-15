extends State

@export var fall_state: State
@export var climb_state: State

@export var JUMP_VELOCITY: float = 10.0

#var speed = parent.WALK_SPEED

func enter() -> void:
	super()
	parent.velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("run"):
		speed = parent.RUN_SPEED
	else:
		speed = parent.WALK_SPEED

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("run"):
		speed = parent.RUN_SPEED
	
	if Input.is_action_pressed("mouse_right"):
		return climb_state
	return null

func process_physics(delta: float) -> State:
	super(delta)
	parent.velocity.y -= (gravity * 1.5) * delta
	
	#Handle camera in air
	parent._camera_controller.jump_camera_handler(parent._camera_point_jump, delta)
	
	if !Input.is_action_pressed("run"):
		speed = parent.WALK_SPEED
	
	#move player toward the direction value and rotate the model
	if direction:
		parent.velocity.x = -direction.x * speed
		parent.velocity.z = -direction.z * speed
		parent._model.rotation.y = lerp_angle(parent._model.rotation.y, atan2(-parent.velocity.x, -parent.velocity.z), parent.LERP_VAL)
	else:
		parent.velocity.x = move_toward(-parent.velocity.x, 0, speed)
		parent.velocity.z = move_toward(-parent.velocity.z, 0, speed)
	parent.move_and_slide()
	
	
	if parent.velocity.y < 0:
		return fall_state
	return null
