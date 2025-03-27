extends State

@export var _idle_state: State
@export var _camera_walk_state: State
@export var _camera_run_state: State
@export var _camera_jump_state: State
@export var _camera_fall_state: State
@export var _camera_stairs_state: State
@export var _crouch_camera_state: State

var in_handheld_camera

# Called when the node enters the scene tree for the first time.
func enter():
	super()
	if GlobalVariables._in_handheld_camera == false: #if not already in a camera state
		parent._handheld_camera.play_camera_handle_sounds() #then play the camera equip sound
	in_handheld_camera = true
	GlobalVariables._in_handheld_camera = true
	number_of_wall_jumps = 0
	tried_mantle = false
	GlobalVariables._number_of_wall_jumps = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released("ctrl"):
		in_handheld_camera = false
		GlobalVariables._in_handheld_camera = false
	if Input.is_action_just_pressed("jump"):
		return _camera_jump_state
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_back"): 
		return _camera_walk_state
	if Input.is_action_pressed("mouse_left"):
		parent._handheld_camera.take_photo()
	if Input.is_action_just_pressed("crouch"):
		return _crouch_camera_state
	return null

func process_physics(delta: float) -> State:
	if in_handheld_camera == true:
		parent.hide_current_packages()
		parent.toggle_camera_reticle(true)#true means reticle is visible
		parent._handheld_camera.toggle_camera_active(true)
		parent._model.visible = false
		if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor() and parent.is_on_wall() and check_movement(): #if moving while on the floor and up against a step
			return _camera_stairs_state
		parent._handheld_camera.set_camera_rotation(parent._camera_controller.get_camera_rotation_horizontal(),parent._camera_controller.get_camera_rotation_vertical()) #set handheld cameras rotation to 3rd person cameras rotation
	elif in_handheld_camera == false:
		#reset camera to third person
		parent.unhide_current_packages()
		parent.toggle_camera_reticle(false) #false means the reticle is not visible
		parent._handheld_camera.toggle_camera_active(false)
		parent._model.visible = true
		parent._camera_controller.set_camera_rotation(parent._handheld_camera.get_camera_rotation_horizontal(),parent._handheld_camera.get_camera_rotation_vertical())#set 3rd person cameras rotation to handheld cameras rotation
		parent._model.rotation.y = parent._camera_controller.get_node("RotateNodeHorizontal").rotation.y + PI# add pi to put the player in the right direction
		parent._climbing_ray_pivot.rotation.y = parent._model.rotation.y
		return _idle_state
	return null

func check_movement() -> bool:
	return Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")

