extends State

@export var _jump_state: State
@export var _camera_fall_state: State
@export var _crouch_camera_state: State
@export var JUMP_VELOCITY: float = 10.0

var in_handheld_camera



# Called when the node enters the scene tree for the first time.
func enter():
	super()
	in_handheld_camera = true
	GlobalVariables._in_handheld_camera = true
	number_of_wall_jumps = 0
	
	if parent.is_on_floor():#if the player presses jump as long as the right conditions are met then we want to apply a jump velocity once. It is easy to do this one time when we enter the state
		parent.velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("run"):
		speed = parent.RUN_SPEED
	else:
		speed = parent.WALK_SPEED

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released("ctrl"):
		in_handheld_camera = false
		GlobalVariables._in_handheld_camera = false
	if Input.is_action_just_pressed("mouse_left"):
		parent._handheld_camera.take_photo()
	if Input.is_action_just_pressed("crouch"):
		return _crouch_camera_state
	return null

func process_physics(delta: float) -> State:
	super(delta)
	if in_handheld_camera == true:
		parent.hide_current_packages()
		parent.toggle_camera_reticle(true)#true means reticle is visible
		direction = parent._handheld_camera.get_direction_from_mouse(direction)
		parent._handheld_camera.toggle_camera_active(true)
		parent._model.visible = false
		
		#--------jump code
		parent.velocity.y -= (gravity * 1.5) * delta # we add what gravity we want to effect the jumping player. In this case less than the fall
		
		if Input.is_action_pressed("run"):
			speed = parent.RUN_SPEED
		elif !Input.is_action_pressed("run"):
			speed = parent.WALK_SPEED
		
		#move player toward the direction value and rotate the model
		if direction:
			parent.velocity.x = -direction.x * speed #we get the amount of direction in the x direction and apply speed to it. Speed allows us to not be super slow
			parent.velocity.z = -direction.z * speed #same but in the z direction
			parent._model.rotation.y = lerp_angle(parent._model.rotation.y, atan2(parent.velocity.x, parent.velocity.z), parent.LERP_VAL) # we rotate the model to match direction, but we dont do it instantaineous
		else:
			parent.velocity.x = move_toward(-parent.velocity.x, 0, speed) #else we bring the player to a
			parent.velocity.z = move_toward(-parent.velocity.z, 0, speed) #gradual stop horizontally
		parent.move_and_slide()
		
		if parent.velocity.y < 0: # if the velocity is negative we are falling
			return _camera_fall_state
		#--------jump code end
		parent._handheld_camera.set_camera_rotation(parent._camera_controller.get_camera_rotation_horizontal(),parent._camera_controller.get_camera_rotation_vertical())#set handheld camera rotation to third person camera rotation
	elif in_handheld_camera == false:
		#reset camera to third person
		parent.unhide_current_packages()
		parent.toggle_camera_reticle(false)#false means reticle is not visible
		direction = parent._camera_controller.get_direction_from_mouse(direction)
		parent._handheld_camera.toggle_camera_active(false)
		parent._model.visible = true
		parent._camera_controller.set_camera_rotation(parent._handheld_camera.get_camera_rotation_horizontal(),parent._handheld_camera.get_camera_rotation_vertical())#set third person camera rotation to handheld camera rotation
		parent._model.rotation.y = parent._camera_controller.get_node("RotateNodeHorizontal").rotation.y + PI# add pi to put the player in the right direction
		parent._climbing_ray_pivot.rotation.y = parent._model.rotation.y
		return _jump_state
	return null
