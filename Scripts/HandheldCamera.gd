extends Node3D

@onready var _camera_camera = $RotateNodeHorizontal/RotateNodeVertical/CameraCamera
@onready var _rotate_node_vertical = $RotateNodeHorizontal/RotateNodeVertical
@onready var _rotate_node_horizontal = $RotateNodeHorizontal

@onready var _camera_sound_player = $CameraSound

@export var _base_ui: BaseUI

@export var _handheld_camera_sesitivity = 0.0001
@export var _player: Player

var picture_count

func _ready():
	var dir = DirAccess.open("user://ingame_camera_photos")
	var pictures_array = dir.get_files()
	if pictures_array.size() != 0:
		picture_count = pictures_array.size()
	else:
		picture_count = 0

func toggle_camera_active(camera_state:bool):
	_camera_camera.current = camera_state

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		#vertical
		_rotate_node_vertical.rotate_x(event.relative.y * _handheld_camera_sesitivity)
		_rotate_node_vertical.rotation.x = clamp(_rotate_node_vertical.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		#horizontal
		_rotate_node_horizontal.rotate_y(-event.relative.x * _handheld_camera_sesitivity)
	
	if Input.is_action_just_pressed("mouse_left") and _player.is_in_handheld_camera() == true: # TODO the first photo will take twice I think hot loading would fix this
		#turn off UI for a second here eventually
		take_photo()
		_base_ui.get_player_ui().get_live_ui().update_pictures()

func take_photo():
	_camera_sound_player.play()
	await RenderingServer.frame_post_draw
	var viewport = get_viewport()
	var img = viewport.get_texture().get_image()
	img.save_png("user://ingame_camera_photos/picture"+str(picture_count)+".png")
	picture_count+=1

func get_direction_from_mouse(direction):
	direction = direction.rotated(Vector3.UP, _rotate_node_horizontal.rotation.y)
	return direction

func set_camera_rotation(horizontal,vertical):
	_rotate_node_vertical.rotation.x = -vertical
	_rotate_node_horizontal.rotation.y = horizontal

func get_camera_rotation_horizontal():
	return _rotate_node_horizontal.rotation.y
func get_camera_rotation_vertical():
	return _rotate_node_vertical.rotation.x
