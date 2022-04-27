extends PopupPanel

func action_popup():
	if not visible:
		popup_centered()
	else:
		visible = false
