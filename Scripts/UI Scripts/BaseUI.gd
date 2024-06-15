class_name BaseUI
extends Node

#TODO ADD ALL BASE UI THINGS THAT MIGHT BE USED IN ALL CHILDREN INHERITED SCENES
#CAMERA IS DEFINITELY NEEDED MAYBE REFRENCES TO ALL CHILDREN? NOT SURE

@export var _camera_controller: CameraController

func _get_camera_controller():
	return _camera_controller

func get_player_ui():
	return get_child(0)
