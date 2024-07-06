extends Node3D

@onready var _camera_camera = $RotateNodeHorizontal/RotateNodeVertical/CameraCamera
@onready var _rotate_node_vertical = $RotateNodeHorizontal/RotateNodeVertical
@onready var _rotate_node_horizontal = $RotateNodeHorizontal

@onready var _camera_sound_player = $CameraSound

@export var _base_ui: BaseUI

@export var _handheld_camera_sesitivity = 0.0001
@export var _player: Player

var picture_count
var live_ui

func _ready():
	var dir = DirAccess.open("user://")
	if dir.dir_exists("user://ingame_camera_photos") == false: #true if exists false if not
		dir.make_dir("user://ingame_camera_photos")
	else:
		dir = DirAccess.open("user://ingame_camera_photos")
	var pictures_array = dir.get_files()
	if pictures_array.size() != 0:
		picture_count = pictures_array.size()
	else:
		picture_count = 0
	live_ui =_base_ui.get_player_ui().get_live_ui()

func toggle_camera_active(camera_state:bool):
	_camera_camera.current = camera_state

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		#vertical
		_rotate_node_vertical.rotate_x(event.relative.y * _handheld_camera_sesitivity) #rotate the handheld cameras vertical node using the y input from the mouse
		_rotate_node_vertical.rotation.x = clamp(_rotate_node_vertical.rotation.x, deg_to_rad(-90), deg_to_rad(90)) #limit the angle the camera can rotate
		#horizontal
		_rotate_node_horizontal.rotate_y(-event.relative.x * _handheld_camera_sesitivity)#rotate the handheld cameras horizontal node. This does need to be limited

func take_photo(): # TODO the first photo will take twice I think hot loading would fix this
	print("in take photo")
	_camera_sound_player.play()
	_base_ui.get_player_ui().get_live_ui().visible = false
	await RenderingServer.frame_post_draw
	var viewport = get_viewport()
	var img = viewport.get_texture().get_image()
	img.save_png("user://ingame_camera_photos/picture"+str(picture_count)+".png")
	picture_count+=1
	live_ui.visible = true
	live_ui.update_pictures()

func get_direction_from_mouse(direction):
	direction = direction.rotated(Vector3.UP, _rotate_node_horizontal.rotation.y)#rotate the direction vector how much the horizontal camera node as rotated on the y axis. Vector 3 UP being the y axis of a Vector3
	return direction

func set_camera_rotation(horizontal,vertical):
	_rotate_node_vertical.rotation.x = -vertical
	_rotate_node_horizontal.rotation.y = horizontal

func get_camera_rotation_horizontal():
	return _rotate_node_horizontal.rotation.y
func get_camera_rotation_vertical():
	return _rotate_node_vertical.rotation.x
