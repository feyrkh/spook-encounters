extends MoveStyle

export(float) var movePixelsPerSecond = 40
export(float) var closingDistance = 30 # How far away should be before stopping

func _process(_delta):
	if (!moveTarget): return
	body.move_and_slide((moveTarget.position - body.position).normalized() * movePixelsPerSecond)
	if (moveTarget.position - body.position).length() < closingDistance:
		moveComplete = true
		moveTarget = null
 
