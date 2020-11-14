extends ScriptStep

export(String) var target # First see if it's a valid node path, then use it to find a node by name if needed
export(String) var moveStyleName # If a movestyle with the given name exists, it will be used. Otherwise, keep the current style.
var moveStyles:MoveStyles


func setGhost(_ghost):
	.setGhost(_ghost)
	moveStyles = _ghost.get_node('move') as MoveStyles

func startStep():
	.startStep()
	if moveStyleName: moveStyles.setMoveStyle(moveStyleName)
	var targetNode = self.get_node_or_null(target) as Position2D
	if !targetNode: targetNode = ghost.get_node_or_null(target) as Position2D
	if !targetNode: targetNode = get_tree().current_scene.find_node(target, true, false) as Position2D
	if targetNode:
		print('moving to ', targetNode)
		moveStyles.startMove(targetNode)
		yield(moveStyles, "moveComplete")
	else:
		print('no targetNode found')
	emit_signal('stepComplete')
