extends State

@export var _camera_idle_state: State
@export var _crouch_state: State
@export var _crouch_camera_walk_state: State
@export var _crouch_camera_stairs_state: State

var in_handheld_camera

# Called when the node enters the scene tree for the first time.
func enter():
	super()
	in_handheld_camera = true
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

func process_physics(delta: float) -> State:
	parent.velocity.y -= (gravity * 2) * delta #while walking apply some gravity to the player
	parent.move_and_slide()
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back"): 
		return _crouch_camera_walk_state
	if in_handheld_camera == true:
		parent.hide_current_packages()
		parent.toggle_camera_reticle(true)#true means reticle is visible
		parent._handheld_camera.toggle_camera_active(true)
		parent._model.visible = false
		if parent._stair_ray_geo_check.is_colliding() and !parent._stair_ray_air_check.is_colliding() and parent.is_on_floor() and parent.is_on_wall() and check_movement(): #if moving while on the floor and up against a step
			return _crouch_camera_stairs_state
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
		return _crouch_state
	return null

func check_movement() -> bool:
	return Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")

