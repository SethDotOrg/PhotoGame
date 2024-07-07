extends State

@export var jump_state: State
@export var ledge_hang_state: State

func enter() -> void:
	super()
	gravity = 0

func process_physics(delta: float) -> State:
	parent._climbing_ray_position_check.add_exception(parent) #exclude the player from getting collided with
	
		#i think i should check if the left and right climbing rays are colliding and then lerp the position to them
	if Input.is_action_pressed("move_left"):
		pass
	if Input.is_action_pressed("move_right"):
		pass
	if Input.is_action_just_pressed("jump"):
		parent.velocity.y = 20 #change this but it looks like just putting the player into the jump state wont do
		return jump_state
	return null
