extends NinePatchRect


# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D/MoveObstruction.shape = RectangleShape2D.new()
	$StaticBody2D/MoveObstruction.shape.extents = self.rect_size/2
	$StaticBody2D/MoveObstruction.position = self.rect_size/2
