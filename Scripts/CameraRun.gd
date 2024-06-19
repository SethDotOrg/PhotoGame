extends State

@export var _run_state: State
@export var _camera_idle_state: State
@export var _camera_walk_state: State
@export var _camera_jump_state: State
@export var _camera_fall_state: State
@export var _camera_stairs_state: State

var in_handheld_camera

# Called when the node enters the scene tree for the first time.
func enter():
	super()
	in_handheld_camera = true
	number_of_wall_jumps = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released("ctrl"):
		in_handheld_camera = false
		#print("set jump pressed false")
		if parent.velocity.x != 0 and parent.velocity.z != 0 and Input.is_action_just_released("run"):
			return _camera_walk_state
	if Input.is_action_just_pressed("jump"):
			return _camera_jump_state
	if Input.is_action_just_pressed("mouse_left"):
		parent._handheld_camera.take_photo()
	return null

func process_physics(delta: float) -> State:
	super(delta)
	if in_handheld_camera == true:
		direction = parent._handheld_camera.get_direction_from_mouse(direction)
		parent._handheld_camera.set_camera_rotation(parent._camera_controller.get_camera_rotation_horizontal(),parent._camera_controller.get_camera_rotation_vertical())
		#fps camera (camera camera)
		#need a aim handler to be called here too similar to the third person one
		parent._handheld_camera.toggle_camera_active(true)
		parent._model.visible = false
		
		#--------run code
		speed = parent.RUN_SPEED
		parent.velocity.y -= (gravity * 2) * delta
		 # REDO MOVEMENT CODE IN HERE FOR 3D MOVEMENT
		
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
			return _camera_idle_state
		if parent.velocity.y < 0:
			return _camera_fall_state
		
		if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor():
			return _camera_stairs_state
			#--------run code end
		
	elif in_handheld_camera == false:
		direction = parent._camera_controller.get_direction_from_mouse(direction)
		#reset camera to third person
		parent._handheld_camera.toggle_camera_active(false)
		parent._model.visible = true
		parent._camera_controller.set_camera_rotation(parent._handheld_camera.get_camera_rotation_horizontal(),parent._handheld_camera.get_camera_rotation_vertical())
		parent._model.rotation.y = parent._camera_controller.get_node("RotateNodeHorizontal").rotation.y
		return _run_state
	return null
