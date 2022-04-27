extends PopupMenu

func _on_iPhone_died(body):
	$Button2.body = body
	popup_centered()
