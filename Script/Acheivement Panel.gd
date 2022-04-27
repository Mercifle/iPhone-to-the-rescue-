extends Panel

func _ready():
	visible = false

func Pop_up(message):
	visible = true
	$Label2.text = message
	$Timer.start()

func _on_Timer_timeout():
	visible = false


