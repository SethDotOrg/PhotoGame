extends Area3D

@export var _letter_e: Sprite3D
@export var _sitting_point: Node3D
@export var _return_point: Node3D
var is_sitting
var is_in_sitting_zone



func _ready():
	_letter_e.visible = false
	is_sitting = false

func _input(event):
	if Input.is_action_just_pressed("interact"):
		self.get_parent().crane_sit_update() #update

func _on_area_entered(area):
	_letter_e.visible = true
	GlobalVariables._in_sit_area = true
	GlobalVariables._sitting_point = _sitting_point
	GlobalVariables._return_point = _return_point

func _on_area_exited(area):
	_letter_e.visible = false
	GlobalVariables._in_sit_area = false
