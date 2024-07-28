class_name Player
extends CharacterBody3D

const WALK_SPEED = 14.0
const RUN_SPEED = 26.0
const JUMP_VELOCITY = 8.0
const LERP_VAL = 0.15

@onready var _animations = $GameModel/AnimationPlayer
@onready var _state_machine = $PlayerStateMachine

@onready var _player_collision_shape = $CollisionShapeNormal
@onready var _standing_collision_check = $CollisionShapeNormal/StandingCollisionCheck
@onready var _player_collision_shape_wall = $CollisionShapeWallHang

@onready var _model = $GameModel
@onready var _camera_point_shoulder = $CameraPointShoulder
@onready var _camera_point_jump = $CameraPointJump
@onready var _camera_point_aim_pivot = $CameraPointAimPivot
@onready var _camera_point_aim_target = $CameraPointAimPivot/CameraPointAimTarget
@onready var _arm_end_right_handle = $GameModel/ArmEndRightHandle
@onready var _footsteps_sound = $Sounds/FootstepAudioPlayer
@onready var _wall_jump_collision = $WallJumpArea3D

@onready var _climbing_ray_pivot = $ClimbingRayPivot
@onready var _climbing_ray_position_check = $ClimbingRayPivot/ClimbingRayPositionCheck
@onready var _climbing_ray_position_check_left = $ClimbingRayPivot/ClimbingRayPositionCheckLeft
@onready var _climbing_ray_position_double_check_left = $ClimbingRayPivot/ClimbingRayPositionCheckLeft/CRPDoubleCheckLeft
@onready var _climbing_ray_position_check_right = $ClimbingRayPivot/ClimbingRayPositionCheckRight
@onready var _climbing_ray_position_double_check_right = $ClimbingRayPivot/ClimbingRayPositionCheckRight/CRPDoubleCheckRight
@onready var _air_ray_center = $ClimbingRayPivot/ClimbingRayPositionCheck/AirRayCenter
@onready var _air_ray_left = $ClimbingRayPivot/ClimbingRayPositionCheckLeft/AirRayLeft
@onready var _air_ray_right = $ClimbingRayPivot/ClimbingRayPositionCheckRight/AirRayRight

@onready var _climbing_ray_forward_center = $ClimbingRayPivot/ClimbingRayForwardCenter 
@onready var _climbing_ray_forward_center_lower = $ClimbingRayPivot/ClimbingRayForwardCenter/ClimbingRayForwardCenterLower
@onready var _climbing_ray_forward_center_higher = $ClimbingRayPivot/ClimbingRayForwardCenter/ClimbingRayForwardCenterHigher
@onready var _ledge_vertical_check = $ClimbingRayPivot/LedgeVerticalCheck
@onready var _ledge_vertical_check_mantle = $ClimbingRayPivot/LedgeVerticalCheckMantle

@onready var _ledge_anchor = $ClimbingRayPivot/LedgeAnchor
@onready var _ledge_anchor_left = $ClimbingRayPivot/LedgeAnchorLeft
@onready var _ledge_anchor_right = $ClimbingRayPivot/LedgeAnchorRight

@onready var _mantle_ray_check_center = $ClimbingRayPivot/MantleRayPositionCheck
@onready var _mantle_ray_check_left = $ClimbingRayPivot/MantleRayPositionCheckLeft
@onready var _mantle_ray_check_right = $ClimbingRayPivot/MantleRayPositionCheckRight
@onready var _mantle_air_ray_center = $ClimbingRayPivot/MantleRayPositionCheck/MantleAirRayCenter
@onready var _mantle_air_ray_left = $ClimbingRayPivot/MantleRayPositionCheckLeft/MantleAirRayLeft
@onready var _mantle_air_ray_right = $ClimbingRayPivot/MantleRayPositionCheckRight/MantleAirRayRight
@onready var _mantle_ray_forward_center = $ClimbingRayPivot/MantleRayForwardCenter
@onready var _mantle_ray_forward_center_higher = $ClimbingRayPivot/MantleRayForwardCenter/MantleRayForwardCenterHigher

@onready var _climbing_ray_geo_check = $ClimbingRayPivot/ClimbingRayGeoCheck
@onready var _climbing_ray_air_check = $ClimbingRayPivot/ClimbingRayAirCheck
@onready var _climbing_ray_geo_check_waist = $ClimbingRayPivot/ClimbingRayGeoCheckWaist
@onready var _climbing_ray_air_check_waist = $ClimbingRayPivot/ClimbingRayAirCheckWaist
@onready var _climbing_ray_geo_check_knee = $ClimbingRayPivot/ClimbingRayGeoCheckKnee
@onready var _climbing_ray_air_check_knee = $ClimbingRayPivot/ClimbingRayAirCheckKnee
@onready var _stair_ray_position_check = $ClimbingRayPivot/StairRayPositionCheck
@onready var _stair_ray_position = $ClimbingRayPivot/StairRayPositionCheck/StairRayPosition
@onready var _stair_ray_geo_check = $ClimbingRayPivot/StairRayGeoCheck
@onready var _stair_ray_air_check = $ClimbingRayPivot/StairRayAirCheck

@onready var _handheld_camera = $HandheldCamera
@onready var package1 = $ClimbingRayPivot/PackageV1_1
@onready var package2 = $ClimbingRayPivot/PackageV1_2
@onready var package3 = $ClimbingRayPivot/PackageV1_3

@export var _camera_controller: CameraController
@export var _world_ledge_anchor: WorldLedgeAnchor

@onready var _base_ui = $BaseUI
var live_ui

var current_package_num

func _ready():
	# Initialize the state machine, passing a reference of the player to the states,
	# so that we can do what we want with the player
	_state_machine.init(self)
	live_ui = _base_ui.get_player_ui().get_live_ui()
	toggle_camera_reticle(false)#false means the camera reticle is not visible
	package1.visible = false
	package2.visible = false
	package3.visible = false

func _unhandled_input(event: InputEvent):
	_state_machine.process_input(event)

func _physics_process(delta: float):
	_state_machine.process_physics(delta)
	#print("player rotation y:: ",self.rotation.y)
	#print("camera horiz rotation:: ",_camera_controller.get_camera_rotation_horizontal())
	#print("camera horiz rotation:: ",_camera_controller.get_camera_rotation_horizontal_degrees())
	#print("player basis y", self.global_transform.basis.y)
	#print("camera basis y", _camera_point_aim_pivot.global_transform.basis.y)
	#print(_climbing_ray_pivot.rotation)
	#print(_camera_point_shoulder.rotation)
	#print("camera horiz rotation:: ", wrapf(rad_to_deg(_camera_controller.get_camera_rotation_horizontal()),0, 360))

func _process(delta: float):
	_state_machine.process_frame(delta)

func toggle_camera_reticle(visible: bool):
	live_ui.toggle_reticle(visible)

func get_camera_node():
	return _camera_controller

func get_direction_from_player(direction):
	direction = direction.rotated(Vector3.UP, self.rotation.y) #rotate the direction vector how much the horizontal camera node as rotated on the y axis. Vector 3 UP being the y axis of a Vector3
	return direction

func get_live_ui():
	return live_ui
func get_base_ui():
	return _base_ui

func hide_current_packages():
	package1.visible = false
	package2.visible = false
	package3.visible = false
func unhide_current_packages():
	#based on package number display the amount picked up
	if current_package_num == 1:
		package1.visible = true
	if current_package_num == 2:
		package1.visible = true
		package2.visible = true
	if current_package_num == 3:
		package1.visible = true
		package2.visible = true
		package3.visible = true

func add_package(package_num:int):
	if package_num == 1:
		package1.visible = true
	if package_num == 2:
		package2.visible = true
	if package_num == 3:
		package3.visible = true
	current_package_num = package_num
	print("CURR PACK: ",current_package_num)
func remove_package(package_num:int):
	if package_num == 0:
		package1.visible = false
	if package_num == 1:
		package2.visible = false
	if package_num == 2:
		package3.visible = false
	current_package_num = package_num

func climb_checks():
	if _climbing_ray_position_check.is_colliding() and !_air_ray_center.is_colliding():
		return true
	elif _climbing_ray_position_check_left.is_colliding() and !_air_ray_left.is_colliding() and _climbing_ray_forward_center_lower.is_colliding():
		return true
	elif _climbing_ray_position_check_right.is_colliding() and !_air_ray_right.is_colliding() and _climbing_ray_forward_center_lower.is_colliding():
		return true
	else:
		return false

func mantle_checks():
	if _mantle_ray_check_center.is_colliding() and !_mantle_air_ray_center.is_colliding():
		return true
	elif _mantle_ray_check_left.is_colliding() and !_mantle_air_ray_left.is_colliding():
		return true
	elif _mantle_ray_check_right.is_colliding() and !_mantle_air_ray_right.is_colliding():
		return true
	else:
		return false
