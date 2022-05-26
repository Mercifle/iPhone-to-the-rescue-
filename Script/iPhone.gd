extends KinematicBody2D

# Walking
export var WalkingSpeed = 100.0
export var RunningSpeed = 250.0
export var GravitySpeed = 30.0
export var JumpingSpeed = 550.0
export var BoostDiSpeed = 250.0
export var CamFollowDistance = 300.0

var Speed = Vector2()
var IsRunning = false

var BoostDirrection = Vector2()
var IsBoosting = false

var Upgrades = 1

onready var AchievementPopup: Panel = get_node("CameraFollow/Camera2D/CanvasLayer/Acheivement Panel")
onready var CheckPoint = position

onready var Tiles: TileMap = get_tree().root.get_node("Node2D").get_node("TileMap")

func _ready():
	randomize()
	
	if SaveManager.pos == null:
		SaveManager.pos = position
	else:
		position = SaveManager.pos
	
	Upgrades = SaveManager.level
	CheckPoint = position
	$CameraFollow.position.x = CamFollowDistance
	$"iPhone detector".text = "iPhone " + str(Upgrades)
	print("NO INTERNET!")
	SaveManager.SaveGame(position, Upgrades)

func _process(_delta):
	# Running
	if Input.is_action_just_pressed("action_RUN_toggle"):
		IsRunning = not IsRunning
	
	# Walking
	if Input.is_action_pressed("action_WALK_right"):
		Speed.x = RunningSpeed if IsRunning else WalkingSpeed
		$Sprite.flip_h = true
		BoostDirrection.x = 1
		$CameraFollow.position.x = CamFollowDistance
	elif Input.is_action_pressed("action_WALK_left"):
		Speed.x = -(RunningSpeed if IsRunning else WalkingSpeed)
		$Sprite.flip_h = false
		BoostDirrection.x = -1
		$CameraFollow.position.x = -CamFollowDistance
	else:
		Speed.x = 0
	
	if Input.is_action_just_pressed("action_jump") and (is_on_floor() or is_on_wall()):
		Speed.y = -JumpingSpeed
	
	if Upgrades >= 6:
		IsBoosting = Input.is_action_pressed("action_boost") and !is_on_floor()
	
	if Upgrades >= 6 and IsBoosting:
		Speed.x = BoostDirrection.x * BoostDiSpeed
		Speed.y = 0
		IsRunning = true
	else:
		# Gravity
		Speed.y += GravitySpeed
	
	if Input.is_action_just_pressed("PauseThatGame!"):
		$CameraFollow/Camera2D/CanvasLayer/PauseMenu/PopupPanel.action_popup()
	
	Speed = move_and_slide(Speed, Vector2.UP)
	
	#Check for death
	var TileNumber = Tiles.get_cellv(Tiles.world_to_map(global_position))
	# Tiles.set_cellv(Tiles.world_to_map(global_position), 67)
	if TileNumber == 51:
		DIE()
	
	if position.y > 400:
		DIE()
	
	# Checkpoint: #52
	if TileNumber == 52:
		CheckPoint = position
		SaveManager.SaveGame(CheckPoint, Upgrades)
		Tiles.set_cellv(Tiles.world_to_map(global_position), -1)

	# Player upgrade: Tile #54
	if TileNumber == 54:
		Upgrades += 1
		Tiles.set_cellv(Tiles.world_to_map(global_position), -1)
		$"iPhone detector".text = "iPhone " + str(Upgrades)
		
		var message = "You are now an iPhone " + str(Upgrades) + "\n"
		
		if Upgrades == 1:
			message += "Press the [SHIFT] key to run"
		elif Upgrades == 3:
			message += "There is no need to worry about the darkness anymore. You have flashlight mode turned on automatically!"
			$BasicLight.visible = false
			get_tree().root.get_node("Node2D").get_node("CanvasModulate").visible = false
			get_tree().root.get_node("Node2D").get_node("ParallaxBackground/ParallaxLayer/CanvasModulate").visible = false
		elif Upgrades == 6:
			message += "You can now boost by pressing the [TAB] key"
		
		AchievementPopup.Pop_up(message)
	
	# Laser tile: Tile #74
	# Horizontal laser tile: Tile #75
	if TileNumber == 74 or TileNumber == 75:
		DIE()
	
	if Input.is_action_just_pressed("debug_ambulance"):
		AmbulanceRespawn()

signal died

func DIE():
	emit_signal("died", self)

func RESPAWN():
	position = CheckPoint

func AmbulanceRespawn():
	var cells = Tiles.get_used_cells_by_id(1)
	var valid_cells = []
	
	for cell in cells:
		var top_cell_position = cell - Vector2(0, 1)
		var top_cell = Tiles.get_cellv(top_cell_position)
		var left_cell_position = cell - Vector2(1, 1)
		var left_cell = Tiles.get_cellv(left_cell_position)
		var right_cell_position = cell - Vector2(-1, 1)
		var right_cell = Tiles.get_cellv(right_cell_position)
		
		if top_cell == -1 and left_cell == -1 and right_cell == -1:
			valid_cells.append(cell)
		
	var index = rand_range(0, len(valid_cells))
	global_position = Tiles.map_to_world(valid_cells[index])
