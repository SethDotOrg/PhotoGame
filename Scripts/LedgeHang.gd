extends State

@export var jump_state: State
@export var ledge_hang_state: State


func enter() -> void:
	super()
	gravity = 0
	speed = 6 
	parent._climbing_ray_forward_center.add_exception(parent) #exclude the player from getting collided with
	parent._climbing_ray_45_left.add_exception(parent) #exclude the player from getting collided with
	parent._climbing_ray_45_right.add_exception(parent) #exclude the player from getting collided with
	
	var collision_point_forward_center = parent._climbing_ray_forward_center.get_collision_point()
	var collision_point_45_left = parent._climbing_ray_45_left.get_collision_point()
	#rotate the player towards the wall
	if parent._climbing_ray_forward_center.is_colliding():
		var fwd_collision = parent._climbing_ray_forward_center.get_collision_point()
		var ledge_y = parent._ledge_vertical_check.get_collision_point().y
		var ledge_point = Vector3(fwd_collision.x,ledge_y,fwd_collision.z)
		parent._world_ledge_anchor.global_position = ledge_point
		
		var wall_normal1 = parent._climbing_ray_forward_center.get_collision_normal()
		print("THe wall normal head :::",wall_normal1)	
		
		parent._world_ledge_anchor.rotate_y(atan2(wall_normal1.x,wall_normal1.z))
		
		parent.look_at(parent._world_ledge_anchor.get_point_to_look_at())
		# TODO tips player on side when looking at point. wont work the way i need to anyway as the point can be slightly to the left or right
		#what i  need to do is match the rotation of the marker somehow. maybe i can change the code below that worked with spawn points
		
		#TODO parent  <--- set variables in parent(a.k.a the player) and whatever neccesary children or sibling nodes  
		#to the same values that the project starts in with. so that the below code can work better. could use it for respawns in spawn point too if i get it working
		
		parent._camera_controller.get_rotate_node_horizontal().rotate_y(parent._world_ledge_anchor.rotation.y)#match the cameras rotation and thus the players direction to the spawn points y rotation
		direction = (parent.transform.basis * Vector3(0, 0, -1)).normalized()  #this is the forward direction input. we need to get this direction to use with getting direction from mouse rotation
		direction = parent._camera_controller.get_direction_from_mouse(direction)
		parent._model.rotate_y(atan2(direction.x, direction.z))#with direction calculated rotate the model instantly to match where the camera is pointing

#TODO Disable player collision wit environment when ledge hanging? will that stop the jitters
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		parent._world_ledge_anchor.rotation.y = 0
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

func process_physics(delta: float) -> State:
	parent._climbing_ray_position_check.add_exception(parent) #exclude the player from getting collided with
	parent._camera_controller.follow_target(parent._camera_point_shoulder, delta)
	if Input.is_action_just_pressed("jump"):
		parent.velocity.y = 20 #change this but it looks like just putting the player into the jump state wont do
		return jump_state
	return null
