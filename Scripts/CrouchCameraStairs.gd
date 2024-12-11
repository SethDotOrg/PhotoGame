extends State

@export var _camera_idle_state: State
@export var _crouch_stairs_state: State
@export var _crouch_camera_state: State
@export var _crouch_camera_walk_state: State


var in_handheld_camera

func enter():
	super()
	in_handheld_camera = true
	GlobalVariables._in_handheld_camera = true
	number_of_wall_jumps = 0
	tried_mantle = false
	parent._stair_ray_position_check.global_position = parent._stair_ray_geo_check.get_collision_point() #check the lower raycast for a collision and get it
	parent._stair_ray_position_check.position.y = parent._stair_ray_air_check.position.y#set the closer to the player vertical raycast to match its original y value
	parent.global_position = (parent.global_position * Vector3(1,0,1))+(parent._stair_ray_position.get_collision_point() * Vector3(0,1,0)) #use the second vertical...
	# raycast that is farther from the player and teleport the player to it. This raycast changes alongside the closer to player raycast
	parent._player_collision_shape_crouch.disabled = false
	parent._player_collision_shape.disabled = true

func exit() -> void:
	parent._player_collision_shape_crouch.disabled = true
	parent._player_collision_shape.disabled = false


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released("ctrl"):
		in_handheld_camera = false
		GlobalVariables._in_handheld_camera = false
	if Input.is_action_pressed("mouse_left"):
		parent._handheld_camera.take_photo()
	if Input.is_action_just_pressed("crouch"):
		parent._crouching_collision_check.enabled = true #enable the raycast for ceiling checks when crouched
		parent._crouching_collision_check.force_raycast_update() #force the raycast update so that we get a good reading no matter the frame
		parent._crouching_collision_check.force_raycast_update()
		if !parent._crouching_collision_check.is_colliding():
			parent._crouching_collision_check.enabled = false
			return _camera_idle_state
	return null

#CAMERA 
func process_physics(delta: float) -> State:
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back"): 
		return _crouch_camera_walk_state
	if in_handheld_camera == true:
		parent.hide_current_packages()
		parent.toggle_camera_reticle(true)#true means reticle is visible
		parent._handheld_camera.toggle_camera_active(true)
		parent._model.visible = false
		#--------stairs code
		#if we are in the camera stairs state then we know we hit the checks to go up a step
		parent._stair_ray_position_check.global_position = parent._stair_ray_geo_check.get_collision_point() #check the lower raycast for a collision and get it
		parent._stair_ray_position_check.position.y = parent._stair_ray_air_check.position.y#set the closer to the player vertical raycast to match its original y value
		parent.global_position = (parent.global_position * Vector3(1,0,1))+(parent._stair_ray_position.get_collision_point() * Vector3(0,1,0)) #use the second vertical...
		# raycast that is farther from the player and teleport the player to it. This raycast changes alongside the closer to player raycast
		if (parent.velocity.x != 0 or parent.velocity.z != 0): #if the player is moving
			return _crouch_camera_walk_state
		elif parent.velocity.x == 0 and parent.velocity.z == 0: #if the player is not moving horizontally
			return _crouch_camera_state
		return null
		#--------stairs code end
		parent._handheld_camera.set_camera_rotation(parent._camera_controller.get_camera_rotation_horizontal(),parent._camera_controller.get_camera_rotation_vertical()) #set handheld cameras rotation to 3rd person cameras rotation
	elif in_handheld_camera == false:
		#reset camera to third person
		parent.unhide_current_packages()
		parent.toggle_camera_reticle(false) #false means the reticle is not visible
		parent._handheld_camera.toggle_camera_active(false)
		parent._model.visible = true
		parent._camera_controller.set_camera_rotation(parent._handheld_camera.get_camera_rotation_horizontal(),parent._handheld_camera.get_camera_rotation_vertical())#set 3rd person cameras rotation to handheld cameras rotation
		parent._model.rotation.y = parent._camera_controller.get_node("RotateNodeHorizontal").rotation.y + PI #add PI to face the model in the right direction
		parent._climbing_ray_pivot.rotation.y = parent._model.rotation.y
		return _crouch_stairs_state
	
	if parent.is_on_floor():
		GlobalVariables._number_of_wall_jumps = 0
	return null
