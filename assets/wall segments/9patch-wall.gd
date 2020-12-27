extends NinePatchRect



# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D/MoveObstruction.shape = RectangleShape2D.new()
	$StaticBody2D/MoveObstruction.shape.extents = Vector2(self.rect_size.x/2, self.rect_size.y/2 - 11)
	$StaticBody2D/MoveObstruction.position = Vector2(self.rect_size.x/2, (self.rect_size.y/2)+11)
	$Topper.visible = true
	yield(get_tree(), "idle_frame")
	resizeWallTopper()
	moveWallToppersAboveEverything()
	
func resizeWallTopper():
	var wallTopper = $Topper
	var topOc = duplicateOccluder($TopOccluder)
	var botOc = duplicateOccluder($BottomOccluder)
	var leftOc = duplicateOccluder($LeftOccluder)
	var rightOc = duplicateOccluder($RightOccluder)
	var boxOc = duplicateOccluder($BoxOccluder)
	
	boxOc.occluder.polygon[0] = Vector2(6, 6)
	boxOc.occluder.polygon[1] = Vector2(rect_size.x - 6, 6)
	boxOc.occluder.polygon[2] = Vector2(rect_size.x - 6, rect_size.y - patch_margin_bottom + 4)
	boxOc.occluder.polygon[3] = Vector2(6, rect_size.y - patch_margin_bottom + 4)
	
	if rect_size.x > (rect_size.y - patch_margin_bottom): #  we are probably stretched left/right
		wallTopper.rect_size.x = rect_size.x
		topOc.occluder.polygon[1].x = rect_size.x
		botOc.occluder.polygon[1].x = rect_size.x
		rightOc.occluder.polygon[0].x = rect_size.x
		rightOc.occluder.polygon[1].x = rect_size.x
	else:
		wallTopper.rect_size.y = rect_size.y 
		wallTopper.visible = false
		botOc.occluder.polygon[0] = Vector2(0,0)
		botOc.occluder.polygon[1] = Vector2(0,rect_size.y)
		topOc.occluder.polygon[0] = Vector2(rect_size.x,0)
		topOc.occluder.polygon[1] = Vector2(rect_size.x,rect_size.y)
		leftOc.queue_free()
		rightOc.queue_free()

func duplicateOccluder(oc):
	var newOc = oc.occluder.duplicate()
	oc.occluder = newOc
	return oc

func moveWallToppersAboveEverything():
	var wallToppersParent = get_tree().get_nodes_in_group('WallTopperParent')
	if wallToppersParent.size() != 1: 
		printerr('Expected group named WallTopperParent with exactly 1 node')
		return
	var wallTopper = $Topper
	wallTopper.get_parent().remove_child(wallTopper)
	wallToppersParent[0].add_child(wallTopper)
	wallTopper.rect_global_position = rect_global_position
	
