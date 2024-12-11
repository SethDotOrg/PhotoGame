extends State

@export var _camera_walk_state: State
@export var _crouch_state: State
@export var crouch_walk_state: State
@export var crouch_camera_state: State
@export var crouch_camera_stairs_state: State

var in_handheld_camera

# Called when the node enters the scene tree for the first time.
func enter():
	super()
	in_handheld_camera = true
	GlobalVariables._in_handheld_camera = true
	number_of_wall_jumps = 0
	tried_mantle = false
	parent._player_collision_shape_crouch.disabled = false
	parent._player_collision_shape.disabled = true
	parent._handheld_camera.global_position = parent._handheld_camera_location_crouch.global_position

func exit() -> void:
	parent._player_collision_shape_crouch.disabled = true
	parent._player_collision_shape.disabled = false
	parent._handheld_camera.global_position = parent._handheld_camera_location_stand.global_position

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released("ctrl"):
		in_handheld_camera = false
		GlobalVariables._in_handheld_camera = false
	if Input.is_action_just_pressed("mouse_left"):
		parent._handheld_camera.take_photo()
	if Input.is_action_just_pressed("crouch"):
		parent._crouching_collision_check.enabled = true #enable the raycast for ceiling checks when crouched
		parent._crouching_collision_check.force_raycast_update() #force the raycast update so that we get a good reading no matter the frame
		if !parent._crouching_collision_check.is_colliding():
			parent._crouching_collision_check.enabled = false
			return _camera_walk_state
	return null

func process_physics(delta: float) -> State:
	super(delta)
	if in_handheld_camera == true:
		parent.hide_current_packages()
		parent.toggle_camera_reticle(true)#true means reticle is visible
		parent._handheld_camera.toggle_camera_active(true)
		parent._model.visible = false
		parent._handheld_camera.set_camera_rotation(parent._camera_controller.get_camera_rotation_horizontal(),parent._camera_controller.get_camera_rotation_vertical())#set handheld camera rotation to match the 3rd person rotation
		direction = parent._handheld_camera.get_direction_from_mouse(direction)
		#--------walk code
		speed = parent.WALK_SPEED
		parent.velocity.y -= (gravity * 2) * delta #while walking apply some gravity to the player
		#move player toward the direction value and rotate the model
		if direction:
			parent.velocity.x = -direction.x * speed #we get the amount of direction in the x direction and apply speed to it. Speed allows us to not be super slow
			parent.velocity.z = -direction.z * speed #same but in the z direction
			parent._model.rotation.y = lerp_angle(parent._model.rotation.y, atan2(parent.velocity.x, parent.velocity.z), parent.LERP_VAL) # we rotate the model to match direction, but we dont do it instantaineous
		else:
			parent.velocity.x = move_toward(-parent.velocity.x, 0, speed) #else we bring the player to a
			parent.velocity.z = move_toward(-parent.velocity.z, 0, speed) #gradual stop horizontally
		parent.move_and_slide()
		
		if parent.is_on_floor():
			GlobalVariables._number_of_wall_jumps = 0
		
		if parent.is_on_floor() and parent.velocity.x == 0 and parent.velocity.z == 0:#if on the floor and not horziontally moving
			return crouch_camera_state
		if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor(): #if on the floor and the stair checks are good
			return crouch_camera_stairs_state
		#---------walk code end
		
	elif in_handheld_camera == false:
		#reset camera to third person
		parent.unhide_current_packages()
		parent.toggle_camera_reticle(false)#false means reticle is not visible
		direction = parent._camera_controller.get_direction_from_mouse(direction)
		parent._handheld_camera.toggle_camera_active(false)
		parent._model.visible = true
		parent._camera_controller.set_camera_rotation(parent._handheld_camera.get_camera_rotation_horizontal(),parent._handheld_camera.get_camera_rotation_vertical()) #set the 3rd person camera rotation to the handheld camera rotation
		parent._model.rotation.y = parent._camera_controller.get_node("RotateNodeHorizontal").rotation.y + PI # add pi to put the player in the right direction
		parent._climbing_ray_pivot.rotation.y = parent._model.rotation.y
		if parent.velocity.x == 0 or parent.velocity.z == 0:#if stopped moving horizontally
			return _crouch_state
		else:
			return crouch_walk_state
	return null
