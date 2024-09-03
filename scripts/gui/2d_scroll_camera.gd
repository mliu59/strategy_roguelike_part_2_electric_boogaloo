extends Camera2D

var ZoomMin = Vector2(0.6,0.6)
var ZoomMax = Vector2(1.5,1.5)
var ZoomSpd = Vector2(0.1,0.1)
var PanSpeedKey = 8


func _ready():
	pass 

func _input(event):
	if event.is_action_pressed("ScrollZoomOut"):
		if zoom > ZoomMin:
			zoom -= ZoomSpd
	if event.is_action_pressed("ScrollZoomIn"):
		if zoom < ZoomMax:
			zoom +=ZoomSpd
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("MoveCamUp"):
		position.y -= PanSpeedKey
	if Input.is_action_pressed("MoveCamDown"):
		position.y += PanSpeedKey
	if Input.is_action_pressed("MoveCamLeft"):
		position.x -= PanSpeedKey
	if Input.is_action_pressed("MoveCamRight"):
		position.x += PanSpeedKey
	pass
