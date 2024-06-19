extends State

@export var idle_state: State
@export var camera_walk: State
@export var camera_run: State
@export var camera_jump: State
@export var camera_fall: State

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
	return null

func process_physics(delta: float) -> State:
	if in_handheld_camera == true:
		#fps camera (camera camera)
		#need a aim handler to be called here too similar to the third person one
		parent._handheld_camera.toggle_camera_active(true)
		parent._model.visible = false
		if Input.is_action_pressed("ctrl"):
			parent._handheld_camera.set_camera_rotation(parent._camera_controller.get_camera_rotation_horizontal(),parent._camera_controller.get_camera_rotation_vertical())
	elif in_handheld_camera == false:
		#reset camera to third person
		parent._handheld_camera.toggle_camera_active(false)
		parent._model.visible = true
		parent._camera_controller.set_camera_rotation(parent._handheld_camera.get_camera_rotation_horizontal(),parent._handheld_camera.get_camera_rotation_vertical())
		parent._model.rotation.y = parent._camera_controller.get_node("RotateNodeHorizontal").rotation.y
		return idle_state
	return null
