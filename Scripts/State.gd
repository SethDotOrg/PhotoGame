#base class for state
class_name State
extends Node

@onready var _base_ui = $"../../BaseUI"
@export var _animation_name: String

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

## Hold a reference to the parent so that it can be controlled by the state
var parent: Player

var input_dir
var direction
var speed
var number_of_wall_jumps
var tried_mantle

func enter() -> void:
	parent._animations.play(_animation_name)
	parent._crouching_collision_check.add_exception(parent) #make it so the ceiling check doesnt hit the player

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	#We get input direction here and change the direction of of player based on that and the camera
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")#returns a 2 axis vector (VECTOR 2)
	direction = (parent.transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()
	
	#direction = -parent.get_direction_from_player(direction)
	#parent._model.rotation.y = parent.rotation.y
	
	parent._climbing_ray_pivot.rotation.y = parent._model.rotation.y
	
	if parent.is_on_floor():
		_base_ui.get_player_ui().get_live_ui().set_walljump_count_text(str(GlobalVariables._number_of_wall_jumps))
	
	#handle camera
	parent._camera_controller.follow_target(parent._camera_point_shoulder, delta)
	return null

func get_state_name() -> String:
	return self.get_name()
