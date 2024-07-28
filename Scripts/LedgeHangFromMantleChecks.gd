extends State

@export var ledge_hang_state: State

func enter() -> void:
	super()
	gravity = 0 
	speed = 3 
	parent._standing_collision_check.enabled = true
	parent._standing_collision_check.add_exception(parent)
	
	parent._player_collision_shape.disabled=true
	parent._player_collision_shape_wall.disabled=false
	parent._mantle_ray_forward_center.add_exception(parent) #exclude the player from getting collided with
	
	parent._mantle_ray_forward_center.global_position.y = parent._mantle_ray_check_center.get_collision_point().y #set the forward climb raycast to be the same y value as the collision from the climbing ray
	parent._mantle_ray_forward_center_lower.force_raycast_update() #force the raycast to update in order to get more reliable collision checks
	if parent._mantle_ray_forward_center_lower.is_colliding(): #if the ray to get wall normals is colliding
		var fwd_collision = parent._mantle_ray_forward_center_lower.get_collision_point() #get the collision from the pink raycast that will help us get the direction the wall is facing
		parent._ledge_vertical_check_mantle.global_position = Vector3(fwd_collision.x, parent._ledge_vertical_check_mantle.global_position.y, fwd_collision.z)#set the vertical collision to the ledge
		parent._ledge_vertical_check_mantle.force_raycast_update()#force the raycast update to insure we get a reliable collision point reading
		var ledge_y = parent._ledge_vertical_check_mantle.get_collision_point().y #get the collision of of the vertical check that will get the y coord of the ledge
		var ledge_point = Vector3(fwd_collision.x,ledge_y,fwd_collision.z) #store the edge point
		parent._world_ledge_anchor.global_position = ledge_point #set the ledge anchor to the ledge the player is trying to climb
		
		var wall_normal = parent._mantle_ray_forward_center_lower.get_collision_normal() #get the walls normal to find out the direction the wall is
		
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

func process_physics(delta: float) -> State:
	#if parent._world_ledge_anchor.get_wall_collision_check().is_colliding():
		#parent.global_position = parent._world_ledge_anchor.get_wall_collision_check().get_collision_point()
	#else:
		#return ledge_hang_state
	return null
