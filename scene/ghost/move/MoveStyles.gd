extends Node
class_name MoveStyles

signal moveComplete

var body:KinematicBody2D
var activeMoveStyle:MoveStyle
var moveInProgress = false

func _ready():
	body = get_parent() as KinematicBody2D
	# The first movement style is always the one enabled to start
	for child in get_children():
		if child.has_method('setBody'): child.setBody(body)
	setMoveStyle(get_child(0).name)

func setMoveStyle(moveNodeName):
	var node = get_node(moveNodeName)
	if !node: return
	for child in get_children():
		child.set_process(false)
	node.set_process(true)
	activeMoveStyle = node

func startMove(target:Position2D):
	activeMoveStyle.startMove(target)
	moveInProgress = true

func _process(_delta):
	if moveInProgress && activeMoveStyle && activeMoveStyle.moveComplete:
		moveInProgress = false
		emit_signal('moveComplete')
