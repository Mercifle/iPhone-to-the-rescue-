extends Button

var body = null

func _pressed():
	get_parent().visible = false
	if body != null:
		body.RESPAWN()
