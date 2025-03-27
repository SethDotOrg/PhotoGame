extends State

@export var _walk_state: State
@export var _run_state: State
@export var _camera_idle_state: State
@export var _camera_walk_state: State
@export var _camera_jump_state: State
@export var _camera_fall_state: State
@export var _camera_stairs_state: State
@export var _crouch_camera_walk_state: State

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
		#print("set jump pressed false")
		if parent.velocity.x != 0 and parent.velocity.z != 0 and Input.is_action_just_released("run") and Input.is_action_pressed("ctrl"): #if moving and
			return _camera_walk_state
	if Input.is_action_just_pressed("jump"):
			return _camera_jump_state
	if Input.is_action_just_pressed("mouse_left"):
		parent._handheld_camera.take_photo()
	if Input.is_action_just_pressed("crouch"):
		return _crouch_camera_walk_state
	return null

func process_physics(delta: float) -> State:
	super(delta)
	if in_handheld_camera == true:
		parent.hide_current_packages()
		parent.toggle_camera_reticle(true)#true means reticle is visible
		direction = parent._handheld_camera.get_direction_from_mouse(direction)
		parent._handheld_camera.set_camera_rotation(parent._camera_controller.get_camera_rotation_horizontal(),parent._camera_controller.get_camera_rotation_vertical())#set handheld camera rotation to third person camera rotation
		parent._handheld_camera.toggle_camera_active(true)
		parent._model.visible = false
		
		#--------run code
		speed = parent.RUN_SPEED
		parent.velocity.y -= (gravity * 2) * delta #set gravity to keep the player on the ground
		#move player toward the direction value and rotate the model
		if direction:
			parent.velocity.x = -direction.x * speed #we get the amount of direction in the x direction and apply speed to it. Speed allows us to not be super slow
			parent.velocity.z = -direction.z * speed #same but in the z direction
			parent._model.rotation.y = lerp_angle(parent._model.rotation.y, atan2(parent.velocity.x, parent.velocity.z), parent.LERP_VAL) # we rotate the model to match direction, but we dont do it instantaineous
		else:
			parent.velocity.x = move_toward(-parent.velocity.x, 0, speed) #else we bring the player to a
			parent.velocity.z = move_toward(-parent.velocity.z, 0, speed) #gradual stop horizontally
		parent.move_and_slide()
		
		if parent.is_on_floor() and parent.velocity.x == 0 and parent.velocity.z == 0: #if on the floor and not horizontally moving
			return _camera_idle_state
		if parent.velocity.y < 0:#if the velocity is negative then the player is falling
			return _camera_fall_state
		
		if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor():#if the player is on the floor and the stair checks are good
			return _camera_stairs_state
			#--------run code end
		
	elif in_handheld_camera == false:
		#reset camera to third person
		parent.unhide_current_packages()
		parent.toggle_camera_reticle(false)#false means reticle is not visible
		direction = parent._camera_controller.get_direction_from_mouse(direction)
		parent._handheld_camera.toggle_camera_active(false)
		parent._model.visible = true
		parent._camera_controller.set_camera_rotation(parent._handheld_camera.get_camera_rotation_horizontal(),parent._handheld_camera.get_camera_rotation_vertical()) #set the third person camera to the handheld cameras rotation
		parent._model.rotation.y = parent._camera_controller.get_node("RotateNodeHorizontal").rotation.y + PI# add pi to put the player in the right direction
		parent._climbing_ray_pivot.rotation.y = parent._model.rotation.y
		if Input.is_action_pressed("run"):
			return _run_state
		elif !Input.is_action_pressed("run"):
			return _walk_state
	return null
