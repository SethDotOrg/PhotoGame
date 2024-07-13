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
	#print("FORWARD COLLISION POINT::::",collision_point_forward_center)
	#print("45 LEFT COLLISION POINT::::",collision_point_45_left)
	#rotate the player towards the wall
	if parent._climbing_ray_forward_center.is_colliding():
		var wall_normal1 = parent._climbing_ray_forward_center.get_collision_normal()
		print("THe wall normal head :::",wall_normal1)
		direction = -wall_normal1 #this is from that youtube video. look back at that for info rn
		parent.to_global(direction)
		#what they do (I think) is set the direction towards the wall on a ledge grab
		print("the new direction",direction)
		#TODO the code below is from spawnpoint. It feels close so maybe its more just tweaking thats needed
		parent._model.rotate_y(atan2(direction.x, direction.z))#TODO i the problem here is that it is local transform so the coords dont match up. but apparently it goes by its parents values so rotating the player might work?
		#parent.rotate_y(atan2(direction.x, direction.z))
		print("model rotate y by:: ",atan2(direction.x, direction.z))
		#TODO if i get the above to match the wall then i could do the same on the two ledge anchors for that movement and 
		#wouldnt need to worry about messing up the camera stuff
		
		#var wall_angle_from_head = Vector3.UP.signed_angle_to(wall_normal1,Vector3.UP)
		#print("wall angle head :: ",wall_angle_from_head)
	
	#print("camera basis y:: ",parent._camera_point_aim_pivot.global_transform.basis.y)
	#print("signed angle:: ",parent.global_transform.basis.y.signed_angle_to(collision_point_45_left,Vector3.UP))
	#print("signed angle with wall normal:: ",parent.global_transform.basis.y.signed_angle_to(parent._climbing_ray_forward_center.get_collision_normal(),Vector3.UP))
	
	#parent.transform.looking_at(wall_normal, Vector3.UP, true)
	#parent._camera_controller.get_rotate_node_horizontal().rotation.y = 0
	#maybe check the wall normals for differences in signage and then act accordingly? z directions work but x doesnt
	#also doesnt work unless we touch the ground basically. It looks like unless the normal getter is already colliding it checks it too fast maybe force an update on the ray before getting the normal?
	#parent._camera_controller.get_rotate_node_horizontal().rotate_y(wall_angle - 3.14159250259399)#match the cameras rotation and thus the players direction to the spawn points y rotation
	#direction = (parent.transform.basis * Vector3(0, 0, -1)).normalized()  #this is the forward direction input. we need to get this direction to use with getting direction from mouse rotation
	#direction = parent._camera_controller.get_direction_from_mouse(direction)
	#parent._model.rotate_y(atan2(direction.x, direction.z))#with direction calculated rotate the model instantly to match where the camera is pointing

#TODO Disable player collision wit environment when ledge hanging? will that stop the jitters
func process_input(event: InputEvent) -> State:
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
