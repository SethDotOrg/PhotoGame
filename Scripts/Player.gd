class_name Player
extends CharacterBody3D

const WALK_SPEED = 10.0
const RUN_SPEED = 14.0
const JUMP_VELOCITY = 8.0
const LERP_VAL = 0.15

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var _model = $GameModel
@onready var _camera_point_shoulder = $CameraPointShoulder
@onready var _camera_point_jump = $CameraPointJump
@onready var _camera_point_aim_pivot = $CameraPointAimPivot
@onready var _camera_point_aim_target = $CameraPointAimPivot/CameraPointAimTarget
@onready var _arm_end_right_handle = $GameModel/ArmEndRightHandle
@onready var _animation_player = $GameModel/AnimationPlayer

@export var _camera_controller: CameraController

func _ready():
	_animation_player.play("Stand")

func _physics_process(delta):

	# Add the gravity.
	#- in future have the jump be a lot shorter OR have it end earlier if the jump key isn't being pressed
	if not is_on_floor():
		velocity.y -= (gravity * 1.5) * delta
		if is_falling():
			velocity.y -= (gravity * 2) * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = _camera_controller.get_direction_from_mouse(direction)
	
	#handle movement speed
	var speed
	if Input.is_action_pressed("run"):
		speed = RUN_SPEED
		_camera_controller.run_fov()
	else:
		speed = WALK_SPEED
		_camera_controller.reset_fov()
	
	if direction:
		velocity.x = -direction.x * speed
		velocity.z = -direction.z * speed
		_model.rotation.y = lerp_angle(_model.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
	else:
		velocity.x = move_toward(-velocity.x, 0, speed)
		velocity.z = move_toward(-velocity.z, 0, speed)
	move_and_slide()
	
	if is_on_floor() and velocity.x or velocity.z > 0:
		_animation_player.play("Walk")
	elif is_on_floor() and velocity.x or velocity.z == 0:
		_animation_player.play("Stand")
	
	#handle camera
	_camera_controller.follow_target(_camera_point_shoulder, delta)
	
	#Handle camera in air
	if !is_on_floor():
		_camera_controller.jump_camera_handler(_camera_point_jump, delta)
	
	#Handle camera for aim
	if Input.is_action_pressed("mouse_right"):
		$GameModel/Armature/Skeleton3D/LeftArmIK.start(false)
		_camera_controller.aim_camera_handler(_camera_point_aim_pivot, _camera_point_aim_target, delta)
		_model.rotation.y = _camera_controller.get_node("RotateNodeHorizontal").rotation.y
		_animation_player.play("Point")
		_arm_end_right_handle.global_position = _camera_controller.get_end_of_raycast_position()
	elif Input.is_action_just_released("mouse_right"):
		$GameModel/Armature/Skeleton3D/LeftArmIK.stop()
		_camera_controller.reset_fov()
		_animation_player.play("Stand")

func is_rising():
	var rising = false
	if velocity.y > 0 and !is_on_floor():
		rising = true
	return rising

func is_falling():
	var falling = false
	if velocity.y < 0 and !is_on_floor():
		falling = true
	return falling
