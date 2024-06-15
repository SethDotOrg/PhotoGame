extends HitscanProjectileBase


var hand_gun_hit = preload("res://Scenes/Particles/HandGunHitParticle.tscn")

func hit_particle(collision_point: Vector3):
	var _hit_particle:Node3D = hand_gun_hit.instantiate()
	add_child(_hit_particle)
	_hit_particle.global_position = collision_point
	_hit_particle.get_node("GPUParticles3D").emitting = true

func update_ammo():
	if current_ammo > 0:
		current_ammo -= 1

func reload():
	current_ammo = _mag_size
	_player_ui.update_hud_ammo(current_ammo,_mag_size)

func set_weapon():
	weapon = _weapon_manager.Weapons.REVOLVER
