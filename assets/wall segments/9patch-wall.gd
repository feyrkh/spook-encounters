extends NinePatchRect



# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D/MoveObstruction.shape = RectangleShape2D.new()
	$StaticBody2D/MoveObstruction.shape.extents = Vector2(self.rect_size.x/2, self.rect_size.y/2 - 11)
	
	$StaticBody2D/MoveObstruction.position = Vector2(self.rect_size.x/2, (self.rect_size.y/2)+11)
	resizeWallTopper()
	moveWallToppersAboveEverything()
	
func resizeWallTopper():
	var wallTopper = $Topper
	if rect_size.x > (rect_size.y - patch_margin_bottom): #  we are probably stretched left/right
		wallTopper.rect_size.x = rect_size.x
	else:
		wallTopper.rect_size.y = rect_size.y
	

func moveWallToppersAboveEverything():
	var wallToppersParent = get_tree().get_nodes_in_group('WallTopperParent')
	if wallToppersParent.size() != 1: 
		printerr('Expected group named WallTopperParent with exactly 1 node')
		return
	var wallTopper = $Topper
	wallTopper.get_parent().remove_child(wallTopper)
	wallToppersParent[0].add_child(wallTopper)
	wallTopper.rect_global_position = rect_global_position
	
