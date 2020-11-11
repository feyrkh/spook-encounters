extends Area2D

signal itemPickupRequested

var itemsInRange = []
var highlightedItem = null
var highlightUpdateTimer = 0

func _process(delta):
	#if Input.is_action_just_pressed("cycle_selected_item"):
	#	cycleSelectedItem()
	if Input.is_action_just_pressed("pickup_item"):
		emit_signal("itemPickupRequested", highlightedItem)
		highlightedItem = null
		yield(get_tree().create_timer(0.001), "timeout")
		updateHighlight()
	if itemsInRange.size():
		highlightUpdateTimer -= delta
		if highlightUpdateTimer <= 0:
			highlightUpdateTimer = 0.1
			updateHighlight()

func updateHighlight():
	# Find the closest-to-the-mouse item in range and highlight it
	var closestDistSquared = 2000000000
	var closestItem = null
	var mousePos:Vector2 = get_global_mouse_position()
	for item in itemsInRange:
		var distSquared = mousePos.distance_squared_to(item.global_position)
		if distSquared < closestDistSquared:
			closestDistSquared = distSquared
			closestItem = item
	if closestItem != highlightedItem: 
		# swap highlights
		if highlightedItem and highlightedItem.has_method('removeItemSelectedHighlight'):
			highlightedItem.removeItemSelectedHighlight()
		if closestItem and closestItem.has_method('addItemSelectedHighlight'):
			closestItem.addItemSelectedHighlight()
		highlightedItem = closestItem

func _on_ItemDetector_area_entered(area):
	print('something entered itemdetector: ', area)
	var item = area.get_parent()
	if item.isHeld: 
		return # Don't count items which are already being held
	itemsInRange.append(item)
	if item.has_method('addItemInRangeHighlight'): 
		print('adding in-range highlight to ', item.name)
		item.addItemInRangeHighlight()
	updateHighlight()

func _on_ItemDetector_area_exited(area):
	print('something left itemdetector: ', area)
	var item = area.get_parent()
	var itemIdx = itemsInRange.find(item)
	if itemIdx >= 0: itemsInRange.remove(itemIdx)
	if item.has_method('removeItemInRangeHighlight'):
		print('removing in-range highlight to ', item.name)
		item.removeItemInRangeHighlight()
	updateHighlight()
