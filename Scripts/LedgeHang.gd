extends State

@export var fall_state: State
@export var jump_state: State
@export var ledge_jump_state: State
@export var ledge_hang_state: State

var low_clamp_angle: float
var high_clamp_angle: float
var XX: bool

func enter() -> void:
	super()
	gravity = 0 
	speed = 3 
	parent._standing_collision_check.enabled = true
	parent._standing_collision_check.add_exception(parent)
	
	parent._player_collision_shape.disabled=true
	parent._player_collision_shape_wall.disabled=false
	parent._climbing_ray_forward_center.add_exception(parent) #exclude the player from getting collided with
	
	parent._climbing_ray_forward_center.global_position.y = parent._climbing_ray_position_check.get_collision_point().y #set the forward climb raycast to be the same y value as the collision from the climbing ray
	parent._climbing_ray_forward_center_lower.force_raycast_update() #force the raycast to update in order to get more reliable collision checks
	if parent._climbing_ray_forward_center_lower.is_colliding(): #if the ray to get wall normals is colliding
		var fwd_collision = parent._climbing_ray_forward_center_lower.get_collision_point() #get the collision from the pink raycast that will help us get the direction the wall is facing
		parent._ledge_vertical_check.global_position = Vector3(fwd_collision.x, parent._ledge_vertical_check.global_position.y, fwd_collision.z)#set the vertical collision to the ledge
		parent._ledge_vertical_check.force_raycast_update()#force the raycast update to insure we get a reliable collision point reading
		var ledge_y = parent._ledge_vertical_check.get_collision_point().y #get the collision of of the vertical check that will get the y coord of the ledge
		var ledge_point = Vector3(fwd_collision.x,ledge_y,fwd_collision.z) #store the edge point
		parent._world_ledge_anchor.global_position = ledge_point #set the ledge anchor to the ledge the player is trying to climb
		
		var wall_normal = parent._climbing_ray_forward_center_lower.get_collision_normal() #get the walls normal to find out the direction the wall is
		
		parent._world_ledge_anchor.rotate_y(atan2(wall_normal.x,wall_normal.z)) #rotate the wall anchor to rotate towards the wall
		
		#set the model and camera horizontal rotation node to zero so that the rotations will work correctly
		#remember that the players forward direction is always -z in our case but that it wont always match up with the global axis
		#so setting these to 0 essentially matches these values to the world axis for a split second
		parent._model.rotation.y = 0
		parent._camera_controller.set_camera_horizontal_rotation(0)
		
		parent._camera_controller.get_rotate_node_horizontal().rotate_y(parent._world_ledge_anchor.rotation.y)#rotate the camera horizontal node to match the rotation of the world anchor
		direction = (parent.transform.basis * Vector3(0, 0, -1)).normalized() #set direction to be straight ahead of the player so that we have a value to work with (the below line requires this)
		direction = parent._camera_controller.get_direction_from_mouse(direction) #then get the direction that the mouse is facing which we have facing the wall now
		parent._model.rotate_y(atan2(direction.x, direction.z)) #then rotate the model based on the direction we just calculated
		parent._climbing_ray_pivot.rotation.y = parent._model.rotation.y #match the climbing pivot to the walls direction so we can do horizontal wall movement

#TODO Disable player collision wit environment when ledge hanging? will that stop the jitters?? can check that the player has enough room to move left and right still tho

#func exit() -> void:
	#parent._player_collision_shape.disabled=false
	#parent._player_collision_shape_wall.disabled=true

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		parent._world_ledge_anchor.rotation.y = 0
	if Input.is_action_just_pressed("run"):
		if parent._standing_collision_check.is_colliding() == false:
			parent._standing_collision_check.enabled = false
			parent._world_ledge_anchor.rotation.y = 0
			return fall_state
	return null

func process_physics(delta: float) -> State:
	parent._camera_controller.follow_target(parent._camera_point_shoulder, delta)
	if Input.is_action_just_pressed("jump"):
			#parent._standing_collision_check.enabled = false
			#parent.velocity.y = 20 #change this but it looks like just putting the player into the jump state wont do
		return ledge_jump_state
	
	if Input.is_action_pressed("move_left") and (parent._climbing_ray_position_check_left.is_colliding() or parent._climbing_ray_position_double_check_left.is_colliding()):
		var ledge_anchor_position = parent._ledge_anchor_left.global_position #use the pre determined left side marker as the position to move towards
		var ledge_move_direction = parent.global_position.direction_to(ledge_anchor_position)# get the direction to the marker
		parent.velocity = ledge_move_direction * speed #move towards its at a desired speed	
		parent.move_and_slide()
	if Input.is_action_pressed("move_right") and (parent._climbing_ray_position_check_right.is_colliding() or parent._climbing_ray_position_double_check_right.is_colliding()):
		var ledge_anchor_position = parent._ledge_anchor_right.global_position #use the pre determined right side marker as the position to move towards
		var ledge_move_direction = parent.global_position.direction_to(ledge_anchor_position) #get the direction to the marker
		parent.velocity = ledge_move_direction * speed #move towards its at a desired speed	
		parent.move_and_slide()
	return null
