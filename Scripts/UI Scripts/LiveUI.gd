class_name Live_UI
extends Control

@onready var _picture_background = $PictureBackground
@onready var _photo_texture_rect = $PictureBackground/TextureRect
@onready var _picture_number = $PictureBackground/PictureNumber
@onready var _text_background = $TextBackground
@onready var _text_background_text = $TextBackground/VBoxContainer/Text

@onready var _state_background = $StateBackground
@onready var _state_text = $StateBackground/StateText
@onready var _walljump_count_text = $Debug/WalljumpCount/CountText
@onready var _walljump_timer_text = $Debug/WalljumpTimer/TimerText
@onready var _wallrun_timer_text = $Debug/WallrunTimer/TimerText
@onready var _wallrun_up_timer_text = $Debug/WallrunUpTimer/TimerText
@onready var _wallrun_to_walljump_up_timer_text = $Debug/WallrunToWalljumpUpTimer/TimerText

@onready var _objective_background = $ObjectiveBackground

@onready var _reticle = $Reticle

var objective_text_ui_scene = preload("res://objective_base_UI.tscn")

var reticle_normal = preload("res://UI Images/CameraReticle.png")
var reticle_photographable = preload("res://UI Images/CameraReticlePhotographable.png")

var dir
var user_photos_array: Array
var array_pos = 0

func _ready():
	update_pictures()
	display_picture(array_pos)
	_picture_background.visible = false
	_text_background.visible = false
	set_objectives()
	

func _unhandled_input(event):
	if Input.is_action_just_pressed("photo_appear(p)"):
		_picture_background.visible = !_picture_background.visible
	
	if Input.is_action_just_pressed("objective_button"):
		_objective_background.visible = !_objective_background.visible
	
	if Input.is_action_just_pressed("debug_toggle"):
		_state_background.visible = !_state_background.visible
	
	if Input.is_action_just_pressed("ui_left"):
		array_pos-=1
		if array_pos <= -1:
			array_pos = user_photos_array.size()-1
		display_picture(array_pos)
	if Input.is_action_just_pressed("ui_right"):
		array_pos+=1
		if array_pos >= user_photos_array.size():
			array_pos = 0
		display_picture(array_pos)

func display_picture(array_pos):
	if user_photos_array.size() != 0:
		#get image and convert it to a texture so that it can be displayed in the ui
		var picture_to_display_img = Image.load_from_file("user://ingame_camera_photos/"+str(user_photos_array[array_pos]))
		var picture_to_display_texture = ImageTexture.create_from_image(picture_to_display_img)
		_photo_texture_rect.texture = picture_to_display_texture
		
		_picture_number.text = "[center]"+str(array_pos+1)+"[/center]"
	

func update_pictures():
	user_photos_array.clear()
	dir = DirAccess.open("user://ingame_camera_photos")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			print("Found file: " + file_name)
			user_photos_array.push_back(file_name)
			file_name = dir.get_next()
		user_photos_array.sort_custom(func(a, b): return a.naturalnocasecmp_to(b) < 0)
	else:
		print("An error occurred when trying to access the path.")

#func get_ammo_count_node():
#	return $AmmoBackground/AmmoCount

func update_state_text(current_state:String):
	_state_text.text = current_state

func display_text_message(text:String):
	_text_background.visible = true
	_text_background_text.text = "[center]"+text+"[/center]"
	await get_tree().create_timer(3).timeout#seconds
	_text_background.visible = false

func toggle_reticle(state:bool):
	_reticle.visible = state

func set_reticle(choice: int):
	if choice == 0:
		_reticle.texture = reticle_normal
	elif choice == 1:
		_reticle.texture = reticle_photographable

func set_objectives(): #go through all level objectives and loop to load them
	#will need to be able to tell what level we are on later
	var curr_level_objectives = GlobalVariables.get_curr_level_objectives().get_children()
	for objective in curr_level_objectives:
		var instance = objective_text_ui_scene.instantiate()
		instance.set_text_for_objective(objective.get_objective_description())
		get_node("ObjectiveBackground/VBoxContainer").add_child(instance)

func update_objectives():
	var curr_level_objectives = GlobalVariables.get_curr_level_objectives().get_children()
	var curr_level_objectives_UI = get_node("ObjectiveBackground/VBoxContainer").get_children()
	var objectives_count = GlobalVariables.get_curr_level_objectives().get_child_count()
	for objective_num in objectives_count:
		if curr_level_objectives[objective_num]._objective_complete == true:
			curr_level_objectives_UI[objective_num].update_text_for_objective_complete()

func set_walljump_count_text(count: String):
	_walljump_count_text.text = "[center]"+count+"[/center]"
func set_walljump_timer_text(time: String):
	_walljump_timer_text.text = "[center]"+time+"[/center]"
func set_wallrun_timer_text(time: String):
	_wallrun_timer_text.text = "[center]"+time+"[/center]"
func set_wallrun_up_timer_text(time: String):
	_wallrun_up_timer_text.text = "[center]"+time+"[/center]"
func set_wallrun_to_walljump_up_timer_text(time: String):
	_wallrun_to_walljump_up_timer_text.text = "[center]"+time+"[/center]"
