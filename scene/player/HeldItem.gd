extends Node2D
class_name HeldItem

# See also MouseRotationPlayerController.gd
export(NodePath) var itemLayer # where to put items that are dropped
enum {None, Left, DownLeft, Down, DownRight, Right, UpRight, Up, UpLeft}
var facing = Right
var heldItem = null

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
	attachPoint.add_child(heldItem)
	heldItem.position = Vector2.ZERO

func unholdItem():
	if heldItem:
		# Already holding an item - it must be going back into inventory, so make it invisible
		heldItem.visible = false
		if heldItem.get_parent() != null:
			heldItem.get_parent().remove_child(heldItem)
	
func dropItem() -> bool:
	if heldItem == null: return false
	heldItem.get_parent().remove_child(heldItem)
	
	get_node(itemLayer).add_child(heldItem)
	heldItem.global_position = getAttachPoint(facing).global_position + getAttachPoint(facing).position + Vector2(0, rand_range(10, 20))
	heldItem.isHeld = false
	if heldItem.has_method('onDrop'):
		heldItem.onDrop()
	emit_signal("itemDropped", heldItem)
	heldItem = null
	return true
	
func _on_MoveController_facingChange(oldFacing, newFacing):
	facing = newFacing
	var oldAttach:Node2D = getAttachPoint(oldFacing)
	if !oldAttach: return
	if oldAttach.get_child_count() == 0: return
	var newAttach:Node2D = getAttachPoint(newFacing)
	if !newAttach: return
	for child in oldAttach.get_children():
		oldAttach.remove_child(child)
		newAttach.add_child(child)

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


#func _on_ItemDetector_itemPickupRequested(newItem):
#	if heldItem: dropItem()
#	pickUpItem(newItem)
