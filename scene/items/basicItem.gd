extends Node2D
class_name BasicItem

var itemInRange = false
var itemSelected = false
var isHeld = false
export(Texture) var itemSlotIconTexture

func updateHighlight():
	if itemSelected: $placeholderImage.setBackgroundColor(Color.lightgray)
	elif itemInRange: $placeholderImage.setBackgroundColor(Color.darkgray)
	else: $placeholderImage.setBackgroundColor(Color.black)

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
	
func onUseItem():
	pass
