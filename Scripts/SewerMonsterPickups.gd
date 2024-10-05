extends Node3D

@onready var  _pickup_1 = $PickupSewerMonster1
@onready var  _pickup_2 = $PickupSewerMonster2
@onready var  _pickup_3 = $PickupSewerMonster3
@onready var  _pickup_4 = $PickupSewerMonster4
@onready var  _pickup_5 = $PickupSewerMonster5

func _process(delta):
	if GlobalVariables._in_handheld_camera == true:
		self.visible = true
		_pickup_1.enable_pickup_collision()
		_pickup_2.enable_pickup_collision()
		_pickup_3.enable_pickup_collision()
		_pickup_4.enable_pickup_collision()
		_pickup_5.enable_pickup_collision()
	elif GlobalVariables._in_handheld_camera == false:
		self.visible = false
		_pickup_1.disable_pickup_collision()
		_pickup_2.disable_pickup_collision()
		_pickup_3.disable_pickup_collision()
		_pickup_4.disable_pickup_collision()
		_pickup_5.disable_pickup_collision()

func update_objective():
	self.get_parent().sewer_monster_update()
