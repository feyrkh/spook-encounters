extends MoveStyle

var nav:Navigation2D
var pathToTarget:Array
var nextPointOnPath:Vector2
export(float) var movePixelsPerSecond = 40
export(float) var closingDistance = 2 # How far away should be before stopping

var pathLine:Line2D
func _ready():
	if !pathLine:
		pathLine = load('res://scene/ghost/PathLine.tscn').instance()
		get_tree().root.call_deferred('add_child', pathLine)
		pathLine.visible = false

func startMove(_moveTarget:Position2D):
	.startMove(_moveTarget)
	nav = get_tree().get_nodes_in_group('NavMeshParent')[0]
	updateNextPointOnPath()

func updateNextPointOnPath():
	if !moveTarget: 
		return
	#var closestPoint = nav.get_closest_point(moveTarget.position)
	pathToTarget = nav.get_simple_path(body.position, moveTarget.position)
	if pathLine: 
		pathLine.points = pathToTarget
		pathLine.visible = true
	if !pathToTarget or pathToTarget.size() < 2 or is_close_to_point(moveTarget.position): 
		moveComplete = true
		moveTarget = null
		emit_signal("move_complete")
		pathLine.visible = false
		return
	nextPointOnPath = pathToTarget[1]

func _process(_delta):
	if (!moveTarget): return
	if pathLine and pathLine.points.size() > 0:
		pathLine.points[0] = body.position
	if !nextPointOnPath: updateNextPointOnPath()
	body.move_and_slide((nextPointOnPath - body.position).normalized() * movePixelsPerSecond)
	if is_close_to_point(nextPointOnPath):
		updateNextPointOnPath()
	
func is_close_to_point(pt):
	return (pt - body.position).length() < closingDistance
