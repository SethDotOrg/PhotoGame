class_name CameraController
extends Node3D

const FOLLOW_FOV = 70.0
const AIM_FOV = 45.0
const RUN_FOV = 75.0
const JUMP_CAM_MOVE_DURATION = 0.4 #seconds
const AIM_CAM_MOVE_DURATION = 0.3 #seconds
const RESET_CAM_MOVE_DURATION = 0.2 #seconds

@onready var _rotate_node_horizontal = $RotateNodeHorizontal
@onready var _rotate_node_vertical = $RotateNodeHorizontal/RotateNodeVertical
@onready var _spring_arm = $RotateNodeHorizontal/RotateNodeVertical/SpringArm3D
@onready var _camera_3D = $RotateNodeHorizontal/RotateNodeVertical/SpringArm3D/Camera3D

@export var _aim_check:RayCast3D
@onready var _end_of_ray = $RotateNodeHorizontal/RotateNodeVertical/SpringArm3D/Camera3D/AimCheck/EndOfRay

@export var mouse_sensitivity := 0.005

#POSSIBLE THINGS
#-On collision auto switch sides (see how it works? Could be an option that can be switched off

func _ready():
	_camera_3D.fov = FOLLOW_FOV

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		#vertical
		_rotate_node_vertical.rotate_x(-event.relative.y * mouse_sensitivity)
		_rotate_node_vertical.rotation.x = clamp(_rotate_node_vertical.rotation.x, deg_to_rad(-90), deg_to_rad(55))
		#horizontal
		_rotate_node_horizontal.rotate_y(-event.relative.x * mouse_sensitivity)

func get_end_of_raycast_position():
	return _end_of_ray.global_position

func get_camera_height():
	return _camera_3D.global_position.y

func get_direction_from_mouse(direction):
	direction = direction.rotated(Vector3.UP, _rotate_node_horizontal.rotation.y)
	return direction

func get_horizontal_rotation():
	return _rotate_node_horizontal.rotation.y #* mouse_sensitivity

func get_vertical_rotation():
	return _rotate_node_vertical.rotation.x #* mouse_sensitivity

func get_aim_cast():
	return _aim_check

func follow_target(follow_target: Node3D, delta):
	#position = position.slerp(follow_target.global_position, 5 * delta) #global position needs to be used for any child node.
	tween_camera_position(follow_target.global_position, RESET_CAM_MOVE_DURATION)

func jump_camera_handler(jump_target: Node3D, delta):
	#position = position.slerp(jump_target.global_position, 3 * delta)\
	tween_camera_position(jump_target.global_position, JUMP_CAM_MOVE_DURATION) 

func aim_camera_handler(aim_pivot: Node3D, aim_target: Node3D, delta):
	#position = position.slerp(aim_target.global_position, 1)
	tween_camera_position(aim_target.global_position, AIM_CAM_MOVE_DURATION)
	#_camera_3D.fov = AIM_FOV
	tween_fov(AIM_FOV)
	aim_pivot.rotation.y = _rotate_node_horizontal.rotation.y
	if Input.is_action_just_pressed("swap_camera-aim_side"):
		aim_target.position.x = -aim_target.position.x

func run_fov():
	#_camera_3D.fov = RUN_FOV
	tween_fov(RUN_FOV)

func reset_fov():
	#_camera_3D.fov = FOLLOW_FOV
	tween_fov(FOLLOW_FOV)

func tween_camera_position(end_pos:Vector3, duration: float):
	var tween = create_tween()
	tween.tween_property(self, "global_position", end_pos, duration)

func tween_fov(end_fov:float):
	var fov_switch_duration = 0.3 #seconds
	var tween = create_tween()
	tween.tween_property(_camera_3D, "fov", end_fov, fov_switch_duration)
	
func set_raycast_distance(raycast_length:float):
	_aim_check.target_position.z = raycast_length

func toggle_dof(dof_state: bool):
	_camera_3D = $RotateNodeHorizontal/RotateNodeVertical/SpringArm3D/Camera3D
	_camera_3D.attributes.dof_blur_far_enabled = dof_state
	_camera_3D.attributes.dof_blur_near_enabled = dof_state	

func set_camera_rotation(horizontal,vertical):
	_rotate_node_vertical.rotation.x = -vertical
	_rotate_node_horizontal.rotation.y = horizontal

func get_camera_rotation_horizontal():
	return _rotate_node_horizontal.rotation.y
func get_camera_rotation_vertical():
	return _rotate_node_vertical.rotation.x
