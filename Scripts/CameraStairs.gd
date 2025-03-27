extends State

@export var _stairs_state: State
@export var _camera_idle_state: State
@export var _camera_walk_state: State
@export var _camera_run_state: State
@export var _camera_jump_state: State
@export var _camera_fall_state: State
@export var _crouch_camera_stairs_state: State

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

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released("ctrl"):
		in_handheld_camera = false
		GlobalVariables._in_handheld_camera = false
	if Input.is_action_just_pressed("jump"):
		return _camera_jump_state
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_back"): 
		return _camera_walk_state
	if Input.is_action_just_pressed("mouse_left"):
		parent._handheld_camera.take_photo()
	if Input.is_action_just_pressed("crouch"):
		return _crouch_camera_stairs_state
	return null

func process_physics(delta: float) -> State:
	if in_handheld_camera == true:
		parent.hide_current_packages()
		parent.toggle_camera_reticle(true)#true means reticle is visible
		parent._handheld_camera.toggle_camera_active(true)
		parent._model.visible = false
		
		#--------stairs code
		#if we are in the camera stairs state then we know we hit the checks to go up a step
		parent._stair_ray_position_check.global_position = parent._stair_ray_geo_check.get_collision_point() #set the vertical stair raycast to the horizontal position the geo check hit
		parent._stair_ray_position_check.position.y = parent._stair_ray_air_check.position.y #set the vertical stair raycast to the y pos of the stair air check
		parent.global_position = (parent.global_position * Vector3(1,0,1))+(parent._stair_ray_position.get_collision_point() * Vector3(0,1,0)) #move the player to the second vertical raycast that moves with the first one
		if (parent.velocity.x != 0 or parent.velocity.z != 0) and Input.is_action_pressed("run"):#if moving and pressing run
			return _camera_run_state
		elif (parent.velocity.x != 0 or parent.velocity.z != 0):#if moving
			return _camera_walk_state
		elif parent.velocity.x == 0 and parent.velocity.z == 0:#if not moving horizontal
			return _camera_idle_state
		#--------stairs code end
		parent._handheld_camera.set_camera_rotation(parent._camera_controller.get_camera_rotation_horizontal(),parent._camera_controller.get_camera_rotation_vertical())#set handheld camera rotation to the third person camera rotation
	elif in_handheld_camera == false:
		#reset camera to third person
		parent.unhide_current_packages()
		parent.toggle_camera_reticle(false)#false means reticle is not visible
		parent._handheld_camera.toggle_camera_active(false)
		parent._model.visible = true
		parent._camera_controller.set_camera_rotation(parent._handheld_camera.get_camera_rotation_horizontal(),parent._handheld_camera.get_camera_rotation_vertical())#set the 3rd person camera rotation to the handheld camera rotation
		parent._model.rotation.y = parent._camera_controller.get_node("RotateNodeHorizontal").rotation.y + PI# add pi to put the player in the right direction
		parent._climbing_ray_pivot.rotation.y = parent._model.rotation.y
		return _camera_idle_state
	return null
