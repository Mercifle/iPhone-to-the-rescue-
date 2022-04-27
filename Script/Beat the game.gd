extends Button

func _pressed():
	print("Pressed game code button")
	get_tree().change_scene("res://Scenes/PasswordScene.tscn")
