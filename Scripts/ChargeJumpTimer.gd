extends Timer

@export var _base_ui: Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_base_ui.get_player_ui().get_live_ui().set_charge_jump_timer_text("cj: "+str("%0.2f" % self.time_left))
