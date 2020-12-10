extends Node2D
class_name BasicItem

# See also MouseRotationPlayerController, HeldItem.gd
enum {None, Left, DownLeft, Down, DownRight, Right, UpRight, Up, UpLeft}

var itemInRange = false
var itemSelected = false
var isHeld = false
var canBePickedUp = true
export var facing = Right

export(Texture) var itemSlotIconTexture

var facingPosition

const itemInRangeMaterial:Material = preload("res://shaders/itemInRangeMaterial.tres")
const itemSelectedMaterial:Material = preload("res://shaders/itemSelectedMaterial.tres")

func _ready():
	facingPosition = get_node_or_null('Facing')
	updateFacing(0, facing, 0)

func updateFacing(oldFacing, newFacing, facingDegrees):
	if facingPosition: facingPosition.rotation_degrees = facingDegrees
	facing = newFacing
	updateTexture()
	
func hideTextures():
	for child in get_children():
		if child.name.ends_with('Held') or child.name.ends_with('Placed'): child.visible = false

func showTexture(specificName, generalName, xScale):
	var node = get_node_or_null(specificName)
	if !node: node = get_node(generalName)
	node.visible = true
	node.scale.x = xScale

func updateTexture():
	print('Updating texture; facing=', facing, ' held=', isHeld)
	hideTextures()
	if isHeld:
		match facing:
			Up: 
				showTexture('UpHeld', 'Held', 1)
			UpRight: 
				showTexture('RightHeld', 'Held', 1)
			Right: 
				showTexture('RightHeld', 'Held', 1)
			DownRight: 
				showTexture('RightHeld', 'Held', 1)
			Down: 
				showTexture('DownHeld', 'Held', 1)
			DownLeft: 
				showTexture('LeftHeld', 'Held', -1)
			Left: 
				showTexture('LeftHeld', 'Held', -1)
			UpLeft: 
				showTexture('LeftHeld', 'Held', -1)
			None: 
				showTexture('RightHeld', 'Held', 1)
	else:
		match facing:
			Up: 
				showTexture('UpPlaced', 'Placed', 1)
			UpRight: 
				showTexture('RightPlaced', 'Placed', 1)
			Right: 
				showTexture('RightPlaced', 'Placed', 1)
			DownRight: 
				showTexture('RightPlaced', 'Placed', 1)
			Down: 
				showTexture('DownPlaced', 'Placed', 1)
			DownLeft: 
				showTexture('RightPlaced', 'Placed', -1)
			Left: 
				showTexture('RightPlaced', 'Placed', -1)
			UpLeft: 
				showTexture('RightPlaced', 'Placed', -1)
			None: 
				showTexture('RightPlaced', 'Placed', 1)
		

func updateHighlight():
	if itemSelected: self.material = itemSelectedMaterial
	elif itemInRange: self.material = itemInRangeMaterial
	else: self.material = null

func addItemSelectedHighlight():
	itemSelected = true
	updateHighlight()

func removeItemSelectedHighlight():
	itemSelected = false
	updateHighlight()

func addItemInRangeHighlight():
	itemInRange = true
	updateHighlight()
	
func removeItemInRangeHighlight():
	itemInRange = false
	updateHighlight()

func onPickup():
	print('picked up')
	$ItemPickupArea.monitorable = false
	isHeld = true
	updateTexture()

func onDrop():
	print('dropped')
	$ItemPickupArea.monitorable = true
	isHeld = false
	updateTexture()

func onUseItem(player):
	pass

func onUseItemWithEmptyHand(player):
	onUseItem(player)
	
func interactWithStationaryItem(player):
	onUseItem(player)
