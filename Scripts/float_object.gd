extends Node3D

@onready var _animation_player = $AnimationPlayer


func start_animation():
	_animation_player.play("ObjectiveMarkFloat")
	_animation_player.active

