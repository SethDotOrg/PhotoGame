extends State

@export var _stairs_state: State
@export var _camera_idle_state: State
@export var _camera_walk_state: State
@export var _camera_run_state: State
@export var _camera_jump_state: State
@export var _camera_fall_state: State

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
	if Input.is_action_just_pressed("jump"):
		return _camera_jump_state
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_back"): 
		return _camera_walk_state
	if Input.is_action_just_pressed("mouse_left"):
		parent._handheld_camera.take_photo()
	return null

func process_physics(delta: float) -> State:
	if in_handheld_camera == true:
		#fps camera (camera camera)
		#need a aim handler to be called here too similar to the third person one
		parent._handheld_camera.toggle_camera_active(true)
		parent._model.visible = false
		
		#--------stairs code
		parent._stair_ray_position_check.global_position = parent._stair_ray_geo_check.get_collision_point()
		parent._stair_ray_position_check.position.y = parent._stair_ray_air_check.position.y
		parent.global_position = (parent.global_position * Vector3(1,0,1))+(parent._stair_ray_position.get_collision_point() * Vector3(0,1,0))
		if (parent.velocity.x != 0 or parent.velocity.z != 0) and Input.is_action_pressed("run"):
			return _camera_run_state
		elif (parent.velocity.x != 0 or parent.velocity.z != 0):
			return _camera_walk_state
		elif parent.velocity.x == 0 and parent.velocity.z == 0:
			return _camera_idle_state
		#--------stairs code end
		
		if Input.is_action_pressed("ctrl"):
			parent._handheld_camera.set_camera_rotation(parent._camera_controller.get_camera_rotation_horizontal(),parent._camera_controller.get_camera_rotation_vertical())
	elif in_handheld_camera == false:
		#reset camera to third person
		parent._handheld_camera.toggle_camera_active(false)
		parent._model.visible = true
		parent._camera_controller.set_camera_rotation(parent._handheld_camera.get_camera_rotation_horizontal(),parent._handheld_camera.get_camera_rotation_vertical())
		parent._model.rotation.y = parent._camera_controller.get_node("RotateNodeHorizontal").rotation.y
		return _camera_idle_state
	return null
