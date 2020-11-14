extends MovementController

func _process(_delta):
	if (!moveTarget): return
	controller.move_and_slide((moveTarget.position - controller.position).normalized() * movePixelsPerSecond)
	if (moveTarget.position - controller.position).length() < closingDistance:
		controller.onMoveFinished(moveTarget)
		moveTarget = null
 
