extends Button

func _pressed():
	SaveManager.NewGame()
	get_tree().change_scene("res://Scenes/The game.tscn")
