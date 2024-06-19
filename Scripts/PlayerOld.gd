extends CharacterBody3D


const WALK_SPEED = 14.0
const RUN_SPEED = 26.0
const JUMP_VELOCITY = 8.0
const LERP_VAL = 0.15

var can_move = true
var can_wall_grab = false
var number_of_wall_jumps = 0 

var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

@onready var _base_ui = $BaseUI
var live_ui

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var _model = $GameModel
@onready var _camera_point_shoulder = $CameraPointShoulder
@onready var _camera_point_jump = $CameraPointJump
@onready var _camera_point_aim_pivot = $CameraPointAimPivot
@onready var _camera_point_aim_target = $CameraPointAimPivot/CameraPointAimTarget
@onready var _arm_end_right_handle = $GameModel/ArmEndRightHandle
@onready var _animation_player = $GameModel/AnimationPlayer
@onready var _footsteps_sound = $Sounds/FootstepAudioPlayer
@onready var _wall_jump_collision = $WallJumpArea3D

@onready var _climbing_ray_pivot = $ClimbingRayPivot
@onready var _climbing_ray_position_check = $ClimbingRayPivot/ClimbingRayPositionCheck
@onready var _climbing_ray_position_check_left = $ClimbingRayPivot/ClimbingRayPositionCheckLeft
@onready var _climbing_ray_position_check_right = $ClimbingRayPivot/ClimbingRayPositionCheckRight
@onready var _air_ray_center = $ClimbingRayPivot/ClimbingRayPositionCheck/AirRayCenter
@onready var _air_ray_left = $ClimbingRayPivot/ClimbingRayPositionCheckLeft/AirRayLeft
@onready var _air_ray_right = $ClimbingRayPivot/ClimbingRayPositionCheckRight/AirRayRight

@onready var _climbing_ray_geo_check = $ClimbingRayPivot/ClimbingRayGeoCheck
@onready var _climbing_ray_air_check = $ClimbingRayPivot/ClimbingRayAirCheck
@onready var _climbing_ray_geo_check_waist = $ClimbingRayPivot/ClimbingRayGeoCheckWaist
@onready var _climbing_ray_air_check_waist = $ClimbingRayPivot/ClimbingRayAirCheckWaist
@onready var _climbing_ray_geo_check_knee = $ClimbingRayPivot/ClimbingRayGeoCheckKnee
@onready var _climbing_ray_air_check_knee = $ClimbingRayPivot/ClimbingRayAirCheckKnee
@onready var _stair_ray_position_check = $ClimbingRayPivot/StairRayPositionCheck
@onready var _stair_ray_geo_check = $ClimbingRayPivot/StairRayGeoCheck
@onready var _stair_ray_air_check = $ClimbingRayPivot/StairRayAirCheck

@onready var _handheld_camera = $HandheldCamera
@onready var package1 = $ClimbingRayPivot/PackageV1_1
@onready var package2 = $ClimbingRayPivot/PackageV1_2
@onready var package3 = $ClimbingRayPivot/PackageV1_3
var in_handheld_camera = false

@export var _camera_controller: CameraController

func _ready():
	_animation_player.play("Stand")
	
	live_ui = _base_ui.get_player_ui().get_live_ui()
	
	package1.visible = false
	package2.visible = false
	package3.visible = false

func _physics_process(delta):
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if can_move==true:
	# Add the gravity.
	#- in future have the jump be a lot shorter OR have it end earlier if the jump key isn't being pressed
		if not is_on_floor():
			velocity.y -= (gravity * 1.5) * delta
			if is_falling():
				velocity.y -= (gravity * 2) * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if in_handheld_camera == true:
			direction = _handheld_camera.get_direction_from_mouse(direction)
		elif in_handheld_camera == false:
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
	#THIRD PERSON AIM
	#if Input.is_action_pressed("mouse_right"):
	#	$GameModel/Armature/Skeleton3D/LeftArmIK.start(false)
	#	_camera_controller.aim_camera_handler(_camera_point_aim_pivot, _camera_point_aim_target, delta)
	#	_model.rotation.y = _camera_controller.get_node("RotateNodeHorizontal").rotation.y
	#	_animation_player.play("Point")
	#	_arm_end_right_handle.global_position = _camera_controller.get_end_of_raycast_position()
	#elif Input.is_action_just_released("mouse_right"):
	#	$GameModel/Armature/Skeleton3D/LeftArmIK.stop()
	#	_camera_controller.reset_fov()
	#	_animation_player.play("Stand")
	
	if Input.is_action_pressed("ctrl"):
		#fps camera (camera camera)
		#need a aim handler to be called here too similar to the third person one
		in_handheld_camera = true
		_handheld_camera.toggle_camera_active(true)
		_model.visible = false
		if Input.is_action_just_pressed("ctrl"):
			_handheld_camera.set_camera_rotation(_camera_controller.get_camera_rotation_horizontal(),_camera_controller.get_camera_rotation_vertical())
	elif Input.is_action_just_released("ctrl"):
		#reset camera to third person
		in_handheld_camera = false
		_handheld_camera.toggle_camera_active(false )
		_model.visible = true
		_camera_controller.set_camera_rotation(_handheld_camera.get_camera_rotation_horizontal(),_handheld_camera.get_camera_rotation_vertical())
		_model.rotation.y = _camera_controller.get_node("RotateNodeHorizontal").rotation.y
	
	#Handle stairs
	# TODO doesnt always work to walk up stairs AS WELL the animation for falling will often play on slopes
	_climbing_ray_pivot.rotation.y = _model.rotation.y#Rotate climb/stair check
	if _stair_ray_geo_check.is_colliding() and not _stair_ray_air_check.is_colliding() and is_on_floor():
		self.global_position = (self.global_position * Vector3(1,0,1))+(_stair_ray_position_check.get_collision_point() * Vector3(0,1,0))
		_stair_ray_position_check.global_position = _stair_ray_geo_check.get_collision_point()
		_stair_ray_position_check.position.y = _stair_ray_air_check.position.y
		_animation_player.play("Walk")
	
	#Handle Climb
	#_climbing_ray_geo_check.add_exception(self)#the player collision will not count towards the ray collision check
	#_climbing_ray_geo_check_waist.add_exception(self)
	_climbing_ray_position_check.add_exception(self)
	_climbing_ray_geo_check_knee.add_exception(self)
	#if _climbing_ray_geo_check.is_colliding() and not _climbing_ray_air_check.is_colliding() and Input.is_action_pressed("run"):
	#	can_move=false
	#	await get_tree().create_timer(1).timeout#seconds
	#	can_move=true
	#	_climbing_ray_position_check.global_position = _climbing_ray_geo_check.get_collision_point()
	#	_climbing_ray_position_check.position.y = _climbing_ray_air_check.position.y
	#	self.global_position = _climbing_ray_position_check.get_collision_point()
	#if _climbing_ray_geo_check_waist.is_colliding() and not _climbing_ray_air_check_waist.is_colliding() and Input.is_action_pressed("run"):
	#	can_move=false
	#	await get_tree().create_timer(1).timeout#seconds
	#	can_move=true
	#	_climbing_ray_position_check.global_position = _climbing_ray_geo_check_waist.get_collision_point()
	#	_climbing_ray_position_check.position.y = _climbing_ray_air_check.position.y
	#	self.global_position = _climbing_ray_position_check.get_collision_point()
	#if _climbing_ray_geo_check_knee.is_colliding() and not _climbing_ray_air_check_knee.is_colliding() and Input.is_action_pressed("run"):
	#if _climbing_ray_geo_check_knee.is_colliding() and not _climbing_ray_air_check.is_colliding() and Input.is_action_pressed("climb") and can_move == true:
	#	velocity = Vector3.ZERO
	#	can_move=false
	#	self.set_process_input(false)
	#	await get_tree().create_timer(0.2).timeout#seconds
	#	self.set_process_input(true)
	#	can_move=true
	#	_climbing_ray_position_check.global_position = _climbing_ray_geo_check_knee.get_collision_point()
	#	_climbing_ray_position_check.position.y = _climbing_ray_air_check.position.y
	#	#_climbing_ray_position_check.position.x = _climbing_ray_air_check.position.x
	#	self.global_position = _climbing_ray_position_check.get_collision_point() 
	if Input.is_action_pressed("mouse_right") and (can_move == true or can_wall_grab == true):
		if _climbing_ray_position_check.is_colliding() and !_air_ray_center.is_colliding():
			velocity = Vector3.ZERO
			can_move=false
			self.set_process_input(false)
			await get_tree().create_timer(0.2).timeout#seconds
			self.set_process_input(true)
			can_move=true
			self.global_position = _climbing_ray_position_check.get_collision_point()
		elif _climbing_ray_position_check_left.is_colliding() and !_air_ray_left.is_colliding():
			velocity = Vector3.ZERO
			can_move=false
			self.set_process_input(false)
			await get_tree().create_timer(0.2).timeout#seconds
			self.set_process_input(true)
			can_move=true
			self.global_position = _climbing_ray_position_check_left.get_collision_point()
		elif _climbing_ray_position_check_right.is_colliding() and !_air_ray_right.is_colliding():
			velocity = Vector3.ZERO
			can_move=false
			self.set_process_input(false)
			await get_tree().create_timer(0.2).timeout#seconds
			self.set_process_input(true)
			can_move=true
			self.global_position = _climbing_ray_position_check_right.get_collision_point()
	
	#Walljump 
	if is_on_wall_only() and Input.is_action_pressed("jump") and can_wall_grab == true: #is there a need to count how many wall grabs have happen before touching the ground?
		velocity=Vector3.ZERO
		can_move= false
		gravity = 0
		can_wall_grab = true
	else:
		if Input.is_action_just_released("jump") and is_on_wall_only() and number_of_wall_jumps == 0:
			number_of_wall_jumps +=1
			velocity.y = 10
		can_move= true
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		can_wall_grab = false
	if is_on_floor():
		number_of_wall_jumps = 0
	if (not is_on_floor() and velocity == Vector3.ZERO) or (not is_on_floor() and velocity != Vector3.ZERO):
		#TODO will play when going up stairs and slopes.. await will only play the anim facing certain ways...wth
	#	await get_tree().create_timer(0.1).timeout
		_animation_player.play("Climb")
		_animation_player.seek(0.58, true, true)

func is_rising():
	var rising = false
	if velocity.y > 0 and !is_on_floor():
		rising = true
	return rising

func is_falling():
	var falling = false
	if velocity.y < 0 and !is_on_floor():
		falling = true
		can_wall_grab = true
	return falling

func get_camera_node():
	return _camera_controller

func get_live_ui():
	return live_ui

func is_in_handheld_camera():
	return in_handheld_camera

func add_package(package_num:int):
	if package_num == 1:
		package1.visible = true
	if package_num == 2:
		package2.visible = true
	if package_num == 3:
		package3.visible = true
func remove_package(package_num:int):
	if package_num == 0:
		package1.visible = false
	if package_num == 1:
		package2.visible = false
	if package_num == 2:
		package3.visible = false
