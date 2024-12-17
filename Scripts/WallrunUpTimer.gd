extends Timer

@export var _base_ui: Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_base_ui.get_player_ui().get_live_ui().set_wallrun_up_timer_text("wru: "+str("%0.2f" % self.time_left))
