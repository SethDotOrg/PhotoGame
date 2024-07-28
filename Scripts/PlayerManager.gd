extends Node3D

@export var _camera_controller: CameraController
@export var _spawn_point: Node3D
@export var _player: Player
@export var _player_spawn: SpawnPoint

var direction

#TODO
# 1: set players (global?) position to the spawn points (global?) position on load -YA
# 2: hide the marker on game load -YA
# 3: make respawn button that will put you back at the marker -YA
# 3: add support for multiple markers? Have a current respawn point that can change somehow, will probably just need to 
#		go through the node tree of spawn points and store their locations

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_player_and_rotate()

func _unhandled_input(event):
	if Input.is_action_just_pressed("num_1"):
		respawn_player()

func spawn_player_and_rotate():
	_camera_controller.get_rotate_node_horizontal().rotate_y(_spawn_point.rotation.y)#match the cameras rotation and thus the players direction to the spawn points y rotation
	direction = (_player.transform.basis * Vector3(0, 0, -1)).normalized()  #this is the forward direction input. we need to get this direction to use with getting direction from mouse rotation
	direction = _camera_controller.get_direction_from_mouse(direction)
	_player._model.rotate_y(atan2(direction.x, direction.z))#with direction calculated rotate the model instantly to match where the camera is pointing
	spawn_player()

func spawn_player():
	_player.global_position = _player_spawn.global_position
	_player_spawn.visible = false

func respawn_player():
	_player.global_position = _player_spawn.global_position
	_player_spawn.visible = false
	
	#set the model and camera horizontal rotation node to zero so that the rotations will work correctly
	#remember that the players forward direction is always -z in our case but that it wont always match up with the global axis
	#so setting these to 0 essentially matches these values to the world axis for a split second
	_player._model.rotation.y = 0
	_player._camera_controller.set_camera_horizontal_rotation(0)
	
	_player._camera_controller.get_rotate_node_horizontal().rotate_y(_spawn_point.rotation.y)#rotate the camera horizontal node to match the rotation of the world anchor
	direction = (_player.transform.basis * Vector3(0, 0, -1)).normalized() #set direction to be straight ahead of the player so that we have a value to work with (the below line requires this)
	direction = _player._camera_controller.get_direction_from_mouse(direction) #then get the direction that the mouse is facing which we have facing the wall now
	_player._model.rotate_y(atan2(direction.x, direction.z)) #then rotate the model based on the direction we just calculated

func get_player_node():
	return _player
