extends Node2D

# See also MouseRotationPlayerController.gd
export(NodePath) var itemLayer # where to put items that are dropped
enum {None, Left, DownLeft, Down, DownRight, Right, UpRight, Up, UpLeft}
var facing = Right
var heldItem = null

func _ready():
	if itemLayer == null:
		itemLayer = '../..'

func _process(delta):
	if Input.is_action_just_pressed('drop_held_item'): dropItem()
	
func pickUpItem(item) -> bool:
	if heldItem != null: return false
	heldItem = item
	if item == null: return false
	if item.has_method('onPickup'):
		item.onPickup()
	var attachPoint:Node2D = getAttachPoint(facing)
	if !attachPoint: return false
	heldItem.get_parent().remove_child(heldItem)
	attachPoint.add_child(heldItem)
	heldItem.position = Vector2.ZERO
	if item.has_method('onPickup'):
		item.onPickup()
	return true
	
func dropItem() -> bool:
	if heldItem == null: return false
	heldItem.get_parent().remove_child(heldItem)
	
	get_node(itemLayer).add_child(heldItem)
	heldItem.global_position = getAttachPoint(facing).global_position + getAttachPoint(facing).position + Vector2(0, rand_range(10, 20))
	if heldItem.has_method('onDrop'):
		heldItem.onDrop()
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

func getAttachPoint(facing):
	match facing:
		Left: return $Left
		DownLeft: return $DownLeft
		UpLeft: return $UpLeft
		Right: return $Right
		DownRight: return $DownRight
		UpRight: return $UpRight
		Up: return $Up
		Down: return $Down


func _on_ItemDetector_itemPickupRequested(newItem):
	if heldItem: dropItem()
	pickUpItem(newItem)
