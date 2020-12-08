extends Node2D
class_name HeldItem

# See also MouseRotationPlayerController.gd
export(NodePath) var itemLayer # where to put items that are dropped
enum {None, Left, DownLeft, Down, DownRight, Right, UpRight, Up, UpLeft}
var facing = Right
var heldItem = null
onready var curAttachPoint = $Right
onready var holdNode = $Held
var curAngleRad = 0

signal item_drop_requested # (heldItem)

func _ready():
	if itemLayer == null:
		itemLayer = '../..'

func holdItem(item):
	var attachPoint:Node2D = getAttachPoint(facing)
	unholdItem()
	heldItem = item
	heldItem.visible = true
	if heldItem.get_parent() != null: 
		heldItem.get_parent().remove_child(heldItem)
	holdNode.add_child(heldItem)
	heldItem.global_position = attachPoint.global_position
	updateHeldItemRotation()
	if heldItem.has_method('onHold'): heldItem.onHold()
	EventBus.emit_signal("setAnimationSuffix", 'HoldItem')

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
	
	get_node(itemLayer).add_child(heldItem)
	heldItem.global_position = getAttachPoint(facing).global_position + getAttachPoint(facing).position + Vector2(0, rand_range(10, 20))
	heldItem.isHeld = false
	if heldItem.has_method('onDrop'):
		heldItem.onDrop()
	heldItem = null
	EventBus.emit_signal("setAnimationSuffix", '')
	return true
	
func _on_MoveController_facingChange(oldFacing, newFacing, angleDegrees):
	facing = newFacing
	var oldAttach:Node2D = getAttachPoint(oldFacing)
	var newAttach:Node2D = getAttachPoint(newFacing)
	curAttachPoint = newAttach
	print('moving from ', oldAttach.name, ' to ', newAttach.name)
	if !newAttach: return
	for child in holdNode.get_children():
		child.global_position = newAttach.global_position

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
	if heldItem:
		curAngleRad = heldItem.rotation + heldItem.get_angle_to(get_global_mouse_position())
		heldItem.rotation = 0
		#heldItem.rotation = curAngleRad
		#print('rotating to ', curAngleRad, '; ', heldItem.global_position, ' -> ', get_global_mouse_position())
		heldItem.rotation = curAngleRad
		#print('heldItem rotation: ', heldItem.rotation_degrees)
