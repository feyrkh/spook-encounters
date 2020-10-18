extends Node2D

var itemInRange = false
var itemSelected = false

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
