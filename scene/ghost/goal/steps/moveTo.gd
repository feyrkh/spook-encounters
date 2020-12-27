extends ScriptStep

export(NodePath) var target # First see if it's a valid node path, then use it to find a node by name if needed
export(NodePath) var targetContainer # if provided, whenever the step is started the target will be set to a random choice from this
export(String) var moveStyleName # If a movestyle with the given name exists, it will be used. Otherwise, keep the current style.
var moveStyles:MoveStyles


func setGhost(_ghost):
	.setGhost(_ghost)
	moveStyles = _ghost.get_node('GhostMoveStyles') as MoveStyles

func startStep():
	.startStep()
	if targetContainer:
		var targetOptions = []
		for child in get_node(targetContainer).get_children():
			if child is Position2D:
				targetOptions.append(child)
		target = targetOptions[randi()%targetOptions.size()].get_path()
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
