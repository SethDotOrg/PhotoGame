extends Area3D

@export var _player: Player

var pickup_count = 0
var live_ui: Live_UI

func _unhandled_input(event):
	#DEBUG
	#if Input.is_action_just_pressed("down_arrow"):
	#	if pickup_count != 0:
	#		pickup_count-= 1
	#		_player.remove_package(pickup_count)
	pass
	
func add_package():
	pickup_count+=1
	_player.add_package(pickup_count)

func get_pickup_count():
	return pickup_count

func get_live_ui(): #need live ui to send messages of packages picked up and if the level is complete etc
	return _player.get_live_ui()

#TODO this might be a good place to access stats. Have the data stored somewhere else but this communicates with other areas and check so yee 
