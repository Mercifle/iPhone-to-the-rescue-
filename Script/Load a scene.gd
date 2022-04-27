extends Button

func _pressed():
	SaveManager.LoadGame()
	get_tree().change_scene("res://Scenes/The game.tscn")
