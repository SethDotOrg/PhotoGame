extends State

@export var idle_state: State


func enter() -> void:
	super()
	get_parent().get_parent().get_parent().set_position_at_point(GlobalVariables._sitting_point)

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("interact"):
		get_parent().get_parent().get_parent().set_position_at_point(GlobalVariables._return_point)
		return idle_state
	return null
