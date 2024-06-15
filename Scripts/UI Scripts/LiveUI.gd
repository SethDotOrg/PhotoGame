class_name Live_UI
extends Control

@onready var _picture_background = $PictureBackground
@onready var _photo_texture_rect = $PictureBackground/TextureRect
@onready var _picture_number = $PictureBackground/PictureNumber
@onready var _text_background = $TextBackground
@onready var _text_background_text = $TextBackground/VBoxContainer/Text


var dir
var user_photos_array: Array
var array_pos = 0

func _ready():
	update_pictures()
	display_picture(array_pos)
	_picture_background.visible = false
	_text_background.visible = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("photo_appear(p)"):
		_picture_background.visible = !_picture_background.visible
	
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

func get_ammo_count_node():
	return $AmmoBackground/AmmoCount

func update_hud_ammo(current_ammo:int, mag_size:int):
	var ammo_count = get_ammo_count_node()
	ammo_count.text = str(current_ammo) + "/" + str(mag_size)

func display_text_message(text:String):
	_text_background.visible = true
	_text_background_text.text = "[center]"+text+"[/center]"
	await get_tree().create_timer(3).timeout#seconds
	_text_background.visible = false

func toggle_reticle(state:bool):
	$Reticle.visible = state

