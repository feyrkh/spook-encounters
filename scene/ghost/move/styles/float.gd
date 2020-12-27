extends MoveStyle

export(float) var movePixelsPerSecond = 40
export(float) var closingDistance = 30 # How far away should be before stopping

var pathLine:Line2D
func _ready():
	if !pathLine:
		pathLine = load('res://scene/ghost/PathLine.tscn').instance()
		get_tree().root.call_deferred('add_child', pathLine)
		pathLine.visible = false

func startMove(_moveTarget:Position2D):
	.startMove(_moveTarget)
	if pathLine:
		pathLine.points = [body.position, _moveTarget.position]

func _process(_delta):
	if (!moveTarget): return
	body.move_and_slide((moveTarget.position - body.position).normalized() * movePixelsPerSecond)
	if pathLine:
		pathLine.points[0] = body.position
	if (moveTarget.position - body.position).length() < closingDistance:
		moveComplete = true
		moveTarget = null
		pathLine = null
 
