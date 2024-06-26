class_name WeaponManager
extends Node3D

@export var _camera_controller: CameraController
@export var _base_ui : BaseUI 
var current_weapon 

@export var _cute_pistol_object: Node3D
@export var _revolver_object: Node3D

@onready var cute_pistol: HitscanProjectileBase = get_child(0)
@onready var revolver: HitscanProjectileBase = get_child(1)

enum Weapons {BASE_GUN, CUTE_PISTOL, REVOLVER} 

func get_current_weapon():
	return current_weapon

#func set_curr_weapon(weapon_index: int):
#	current_weapon = get_weapon_node(weapon_index)

func set_curr_weapon(weapon_choice):
	current_weapon = weapon_choice

func get_weapon_node(index):
	return get_child(index)

func get_camera_controller():
	return _camera_controller

func get_player_ui():
	return _base_ui.get_player_ui()

#kept here incase it can be usefull later
#func _unhandled_input(event):
	
	#handle weapon changes (COULD DEFINITELY BE BETTER)----- kept here incase it can be usefull later
	#if Input.is_action_just_pressed("num_1"):
		#set_curr_weapon(Weapons.CUTE_PISTOL)
		#_cute_pistol_object.visible = true
		#_revolver_object.visible = false
		#cute_pistol.update_ammo_in_hud()
	#if Input.is_action_just_pressed("num_2"):
		#set_curr_weapon(Weapons.REVOLVER)
		#_cute_pistol_object.visible = false
		#_revolver_object.visible = true
		#revolver.update_ammo_in_hud()
