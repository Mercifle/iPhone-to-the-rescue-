extends LineEdit

func _process(delta):
	if len(text) < 10 and Input.is_action_pressed ("ui_accept"):
		$WarningLabel.visible = true
