#base class for state
class_name State
extends Node

@export var _animation_name: String

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

## Hold a reference to the parent so that it can be controlled by the state
var parent: Player

var input_dir
var direction
var speed

func enter() -> void:
	#parent.animations.play(_animation_name)    add this back when deaing with animations
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	# I believe I should handle camera here since it is used in all states
	
	#We get input direction here and change the direction of of player based on that and the camera
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = parent._camera_controller.get_direction_from_mouse(direction)
	
	#handle camera
	parent._camera_controller.follow_target(parent._camera_point_shoulder, delta)
	return null
