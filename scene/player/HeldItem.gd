extends Node2D
class_name HeldItem

# See also MouseRotationPlayerController.gd, basicItem.gd
var itemLayer # where to put items that are dropped
enum {None, Left, DownLeft, Down, DownRight, Right, UpRight, Up, UpLeft}
var facing = Right
var heldItem = null
onready var curAttachPoint = $Right
onready var holdNode = $Held
var curAngleRad = 0

signal item_drop_requested # (heldItem)

func _ready():
	itemLayer = get_tree().get_nodes_in_group('ItemLayer')[0]
	var t:Timer = Timer.new()
	add_child(t)
	t.one_shot = false
	t.start(3)
	t.connect('timeout', self, 'print_data')

func holdItem(item):
	var attachPoint:Node2D = getAttachPoint(facing)
	unholdItem()
	heldItem = item
	heldItem.visible = true
	if heldItem.get_parent() != null: 
		heldItem.get_parent().remove_child(heldItem)
	holdNode.add_child(heldItem)
	updateAttachPoint(facing)
	updateHeldItemRotation()
	if heldItem.has_method('onHold'): heldItem.onHold()
	EventBus.emit_signal("setAnimationSuffix", 'HoldItem')

func print_data():
	if heldItem:
		print('heldItem: ', heldItem)
		print('  pos   : ', heldItem.global_position)
		print('  rot   : ', heldItem.rotation)
	if curAttachPoint:
		print('attachPt: ', curAttachPoint.name)
		print('  pos   : ', curAttachPoint.global_position)
		print('  rot   : ', curAttachPoint.rotation)
	if holdNode:
		print('holdNode: ', holdNode.name)
		print('  pos   : ', holdNode.global_position)
		print('  rot   : ', curAttachPoint.rotation)

func unholdItem():
	if heldItem:
		if heldItem.has_method('onUnHold'): heldItem.onUnHold()
		# Already holding an item - it must be going back into inventory, so make it invisible
		heldItem.visible = false
		if heldItem.get_parent() != null:
			heldItem.get_parent().remove_child(heldItem)
		EventBus.emit_signal("setAnimationSuffix", '')
	
func dropItem() -> bool:
	if heldItem == null: return false
	heldItem.get_parent().remove_child(heldItem)
	
	itemLayer.add_child(heldItem)
	heldItem.global_position = getAttachPoint(facing).global_position + getAttachPoint(facing).position + Vector2(0, rand_range(10, 20))
	heldItem.isHeld = false
	if heldItem.has_method('onDrop'):
		heldItem.onDrop()
	heldItem = null
	EventBus.emit_signal("setAnimationSuffix", '')
	return true
	
func _on_MoveController_facingChange(oldFacing, newFacing, angleDegrees):
	facing = newFacing
	if heldItem && heldItem.has_method('updateFacing'): heldItem.updateFacing(oldFacing, newFacing, angleDegrees)
	updateAttachPoint(newFacing)

func updateAttachPoint(newFacing):
	var newAttach:Node2D = getAttachPoint(newFacing)
	curAttachPoint = newAttach
	print('moving attach point to ', newAttach.name)
	for child in holdNode.get_children():
		child.position = Vector2.ZERO
		if child.has_method('updateFacing'): child.updateFacing(0, newFacing, rad2deg(curAngleRad))
	holdNode.global_position = newAttach.global_position
	

func getAttachPoint(_facing):
	match _facing:
		Left: return $Left
		DownLeft: return $DownLeft
		UpLeft: return $UpLeft
		Right: return $Right
		DownRight: return $DownRight
		UpRight: return $UpRight
		Up: return $Up
		Down: return $Down


func _on_MoveController_updateFacingAngle(newPlayerAngle):
		updateHeldItemRotation()

func updateHeldItemRotation():
	if heldItem && heldItem.has_method('updateRotation'):
		var mouseDistance = heldItem.global_position.distance_to(get_global_mouse_position())
		if mouseDistance < 2: return
		curAngleRad = heldItem.rotation + heldItem.get_angle_to(get_global_mouse_position())
		heldItem.updateRotation(curAngleRad)
#		heldItem.rotation = 0
#		heldItem.rotation = curAngleRad
