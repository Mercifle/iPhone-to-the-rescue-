extends Node

var pos = null
var level = 1

func LoadGame():
	var file = File.new()
	file.open("user://FileGame.sav", File.READ)
	
	if pos == null:
		pos = Vector2()
	
	pos.x = file.get_float()
	pos.y = file.get_float()
	level = file.get_16()
	file.close()
	
func SaveGame(Position, new_level):
	var file = File.new()
	file.open("user://FileGame.sav", File.WRITE)
	file.store_float(Position.x)
	file.store_float(Position.y)
	file.store_16(new_level)
	file.close()

func NewGame():
	var file = File.new()
	file.open("user://FileGame.sav", File.WRITE)
	file.close()
	pos = null
	level = 1
