extends Node

func _ready():
	# The first movement style is always the one enabled to start
	for child in get_children():
		child.set_process(false)
	get_children()[0].set_process(true)

func setMoveStyle(moveNodeName):
	for child in get_children():
		child.set_process(false)
	var node = get_node('moveNodeName')
	if !node: node = get_children()[0]
	node.set_process(true)
