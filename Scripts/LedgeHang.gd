extends State

@export var jump_state: State
@export var ledge_hang_state: State

@onready var timer = $Timer

func enter() -> void:
	super()
	gravity = 0

func process_physics(delta: float) -> State:
	parent._climbing_ray_position_check.add_exception(parent) #exclude the player from getting collided with
	
		#i think i should check if the left and right climbing rays are colliding and then lerp the position to them
	if Input.is_action_pressed("move_left") and parent._climbing_ray_position_check_left.is_colliding():
		self.set_process_input(false)
		timer.wait_time = 1.0
		timer.one_shot = true
		timer.start()
		print(timer.time_left)
		self.set_process_input(true)
		var ledge_point = parent._ledge_anchor_left.global_position #get the collision of the ray to the left
		var ledge_y = ledge_point.y - parent._ledge_anchor.position.y #since the position of the player is at the models feet we want to minus the height from the feet to where we want the player to grab the ledge
		var player_ledge_point = Vector3(ledge_point.x,ledge_y,ledge_point.z)#store a variable with the ray collision point for x and z but also use the modified y 
		parent.global_position = player_ledge_point #bring the player to that mix of coords
	if Input.is_action_just_pressed("move_right") and parent._climbing_ray_position_check_right.is_colliding():
		pass
	if Input.is_action_just_pressed("jump"):
		parent.velocity.y = 20 #change this but it looks like just putting the player into the jump state wont do
		return jump_state
	return null
