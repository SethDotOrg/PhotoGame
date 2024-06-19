class_name HitscanProjectileBase
extends Node3D

@onready var _audio_stream_player = $ProjectileFireSound
@export var _audio_stream_player_3D : Node3D

var _camera_controller: CameraController
var _player_ui : UI
var _weapon_manager: WeaponManager
var weapon
@export var _mag_size: int = 1
@export var _damage: int = 1
@export var _weapon_range: float = 100

var hit = preload("res://Scenes/Particles/BaseHitParticle.tscn")

var current_ammo: int

#func init() MAYBE CAN BE USED FOR NOT LAG ON FIRST SHOT

func _ready():
	current_ammo = _mag_size
	_camera_controller = self.get_parent().get_camera_controller() #Will access the WeaponManagerNode
	_player_ui = self.get_parent().get_player_ui() #Will access the WeaponManagerNode
	_weapon_manager = self.get_parent()
	set_weapon()
#	_player_ui.update_hud_ammo(current_ammo, _mag_size)
	_camera_controller.set_raycast_distance(_weapon_range)

func _unhandled_input(_event):
	if Input.is_action_pressed("mouse_right"):#Requires aiming down the sights
		if Input.is_action_just_pressed("mouse_left") and get_current_ammo() > 0 and _weapon_manager.get_current_weapon() == weapon:
			#await get_tree().create_timer(0.1).timeout #seconds
			_audio_stream_player.play()
			_camera_controller.get_aim_cast().force_raycast_update()
			update_ammo()
			update_ammo_in_hud()
			if _camera_controller.get_aim_cast().is_colliding():
				hit_particle(_camera_controller.get_aim_cast().get_collision_point())
				_audio_stream_player_3D.global_position = _camera_controller.get_aim_cast().get_collision_point()
				_audio_stream_player_3D.play()
				if _camera_controller.get_aim_cast().get_collider().is_in_group("Shootables"):
					print("hit", _camera_controller.get_aim_cast().get_collider())
					_camera_controller.get_aim_cast().get_collider().hide()
					_camera_controller.get_aim_cast().get_collider().use_collision = false
	
	if Input.is_action_just_pressed("reload"):
		reload()

func hit_particle(collision_point: Vector3):
	var _hit_particle = hit.instantiate()
	add_child(_hit_particle)
	_hit_particle.global_position = collision_point
	_hit_particle.get_node("GPUParticles3D").emitting = true

func get_current_ammo():
	return current_ammo

func get_mag_size():
	return _mag_size

func update_ammo():
	pass

func update_ammo_in_hud():
	_player_ui.update_hud_ammo(current_ammo, _mag_size)

func reload():
	pass

func set_weapon():
	pass
	#weapon = _weapon_manager.Weapons.theweapon
