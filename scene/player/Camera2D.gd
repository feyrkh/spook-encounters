extends Camera2D
 
### Base Size of the Game ###
const baseSize = Vector2(1920/12,1080/12)
 
### Black Bars ###
var blackBarSize = Vector2()

onready var defaultZoom = zoom.x
 
 
func _ready():
	var cameraSize = get_best_camera_size(OS.window_size)
	set_zoom(Vector2((cameraSize.x/baseSize.x),(cameraSize.y/baseSize.y)))
	blackBarSize = (cameraSize - baseSize)/2
 
 
func get_best_camera_size(screenSize):
	var bestResizeX = floor(screenSize.x/baseSize.x/defaultZoom)
	var bestResizeY = floor(screenSize.y/baseSize.y/defaultZoom)
	
	if (bestResizeX <= bestResizeY):
		return screenSize / bestResizeX
	return screenSize / bestResizeY
 
 
#Draw the black bars on the sides to hide other elements
#you can also add other drawable elements here
#or put your Hud here for other device that have bottom space
func _draw():
	var black = Color(0,0,0,1)
 
	draw_rect(Rect2(Vector2(-blackBarSize.x-(baseSize.x/2),-(baseSize.y/2)),Vector2(256+(blackBarSize.x*2),-blackBarSize.y)),black)
	draw_rect(Rect2(Vector2(-blackBarSize.x-(baseSize.x/2),(baseSize.y/2)),Vector2(256+(blackBarSize.x*2),blackBarSize.y)),black)
	draw_rect(Rect2(Vector2(-(baseSize.x/2),-(baseSize.y/2)),Vector2(-blackBarSize.x,baseSize.y)),black)
	draw_rect(Rect2(Vector2((baseSize.x/2),-(baseSize.y/2)),Vector2(blackBarSize.x,baseSize.y)),black)
