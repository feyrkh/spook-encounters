extends Node2D
class_name BasicItem

var itemInRange = false
var itemSelected = false
var isHeld = false
var canBePickedUp = true
export(Texture) var itemSlotIconTexture

const itemInRangeMaterial:Material = preload("res://shaders/itemInRangeMaterial.tres")
const itemSelectedMaterial:Material = preload("res://shaders/itemSelectedMaterial.tres")

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
	$ItemPickupArea.monitorable = false

func onDrop():
	$ItemPickupArea.monitorable = true

func onUseItem(player):
	pass

func onUseItemWithEmptyHand(player):
	onUseItem(player)
	
func interactWithStationaryItem(player):
	onUseItem(player)
