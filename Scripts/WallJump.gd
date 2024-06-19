extends State

@export var jump_state: State

var jump_pressed = true

func enter():
	jump_pressed = true
	#print("set jump pressed true")

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released("jump"):
		jump_pressed = false
		#print("set jump pressed false")
	return null

func process_physics(delta: float) -> State:
	#is there a need to count how many wall grabs have happen before touching the ground?
	if jump_pressed == true:
		parent.velocity=Vector3.ZERO
		gravity = 0
		#print("Jump pressed")
	
	if parent.is_on_wall_only() and jump_pressed == false:
		#number_of_wall_jumps +=1
		parent.velocity.y = 10
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		#print("Jump unpressed")
		return jump_state
	else:
		return null

