extends Area3D

@export var _letter_e: Sprite3D
@export var _sitting_point: Node3D
@export var _return_point: Node3D
var is_sitting
var is_in_sitting_zone

func _ready():
	_letter_e.visible = false
	is_sitting = false

func _process(delta): #TODO need to stop movement while sitting and change animations when in sitting position and wh
	#leaving the sitting position
	if is_in_sitting_zone:
		if Input.is_action_just_pressed("interact") && is_sitting == false:
			print("interact pressed")
			is_sitting = true
			print(is_sitting)
			get_parent().get_parent().get_player_holder_node().set_position_at_point(_sitting_point)
		elif Input.is_action_just_pressed("interact") && is_sitting == true:
			print("interact pressed again")
			is_sitting = false
			print(is_sitting)
			get_parent().get_parent().get_player_holder_node().set_position_at_point(_return_point)

func _on_area_entered(area):
	_letter_e.visible = true
	is_in_sitting_zone = true

func _on_area_exited(area):
	_letter_e.visible = false
	is_in_sitting_zone = false
