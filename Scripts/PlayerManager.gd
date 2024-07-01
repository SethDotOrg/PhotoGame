extends Node3D

@export var _camera_controller: CameraController
@export var _spawn_point: Node3D
@export var _player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	_camera_controller.get_rotate_node_horizontal().rotate_y(_spawn_point.rotation.y)#match the cameras rotation and thus the players direction to the spawn points y rotation
	_player.move_player_forward()
	_player._model.rotation.y = lerp_angle(_player._model.rotation.y, atan2(-_player.velocity.x, -_player.velocity.z), _player.LERP_VAL) # we rotate the model to match direction, but we dont do it instantaineous
