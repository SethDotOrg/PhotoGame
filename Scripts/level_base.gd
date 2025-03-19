extends Node3D

@export var _seagull_animation_player: AnimationPlayer
@export var _seagulls_animation_player: AnimationPlayer

func _ready():
	_seagull_animation_player.play("SeagullDive")
	_seagulls_animation_player.play("Seagulls Flying")

func get_objective_node():
	return get_node("LevelObjectives")
	
func get_player_node():
	return get_parent().get_player_node()

func get_player_holder_node():
	return get_parent().get_player_holder_node()
 
