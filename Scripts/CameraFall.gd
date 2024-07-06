extends State

@export var _fall_state: State
@export var _camera_idle_state: State
@export var _camera_walk_state: State
@export var _camera_run_state: State
@export var _camera_jump_state: State

var in_handheld_camera

# Called when the node enters the scene tree for the first time.
func enter():
	super()
	in_handheld_camera = true
	number_of_wall_jumps = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released("ctrl"):
		in_handheld_camera = false
	if Input.is_action_just_pressed("mouse_left"):
		parent._handheld_camera.take_photo()
	return null

func process_physics(delta: float) -> State:
	super(delta)
	if in_handheld_camera == true:
		parent.hide_current_packages()
		parent.toggle_camera_reticle(true)#true means reticle is visible
		direction = parent._handheld_camera.get_direction_from_mouse(direction)
		parent._handheld_camera.toggle_camera_active(true)
		parent._model.visible = false
		#--------fall code
		parent.velocity.y -= (gravity * 2) * delta #can apply different forces on the player for fall state. In this case we want the player to fall faster then when jumping
		
		if Input.is_action_pressed("run"):
			speed = parent.RUN_SPEED
		elif !Input.is_action_pressed("run"):
			speed = parent.WALK_SPEED
		
		#move player toward the direction value and rotate the model
		if direction:
			parent.velocity.x = -direction.x * speed #we get the amount of direction in the x direction and apply speed to it. Speed allows us to not be super slow
			parent.velocity.z = -direction.z * speed #same but in the z direction
			parent._model.rotation.y = lerp_angle(parent._model.rotation.y, atan2(-parent.velocity.x, -parent.velocity.z), parent.LERP_VAL) # we rotate the model to match direction, but we dont do it instantaineous
		else:
			parent.velocity.x = move_toward(-parent.velocity.x, 0, speed) #else we bring the player to a
			parent.velocity.z = move_toward(-parent.velocity.z, 0, speed) #gradual stop horizontally
		parent.move_and_slide()
		
		if parent.is_on_floor():
			if parent.velocity.x != 0 and parent.velocity.z != 0 and parent.is_on_floor() and Input.is_action_pressed("run"): #if moving while pressing run on the floor
				return _camera_run_state
			elif parent.velocity.x != 0 and parent.velocity.z != 0 and parent.is_on_floor(): #if moving while on the floor
				return _camera_walk_state
			return _camera_idle_state
		#--------fall code end
		parent._handheld_camera.set_camera_rotation(parent._camera_controller.get_camera_rotation_horizontal(),parent._camera_controller.get_camera_rotation_vertical()) #set the handheld camera to match the 3rd person cameras rotation
	elif in_handheld_camera == false:
		#reset camera to third person
		parent.unhide_current_packages()
		parent.toggle_camera_reticle(false)#false means reticle is not visible
		parent._handheld_camera.toggle_camera_active(false)
		parent._model.visible = true
		parent._camera_controller.set_camera_rotation(parent._handheld_camera.get_camera_rotation_horizontal(),parent._handheld_camera.get_camera_rotation_vertical()) # set third person camera to match handhld cameras rotation
		parent._model.rotation.y = parent._camera_controller.get_node("RotateNodeHorizontal").rotation.y
		parent._climbing_ray_pivot.rotation.y = parent._model.rotation.y
		return _fall_state
	return null
