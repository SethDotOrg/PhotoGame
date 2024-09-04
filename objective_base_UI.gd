extends RichTextLabel

var objective_text

func set_text_for_objective(text_to_set: String):
	self.bbcode_enabled = true
	self.fit_content = true
	
	objective_text = text_to_set
	self.text = "[center]"+text_to_set+"[/center]"
