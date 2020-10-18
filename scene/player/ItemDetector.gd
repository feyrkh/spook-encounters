extends Area2D

signal itemPickupRequested

var itemsInRange = []
var highlightedItem = null

func _process(delta):
	if Input.is_action_just_pressed("cycle_selected_item"):
		cycleSelectedItem()
	if Input.is_action_just_pressed("pickup_item"):
		emit_signal("itemPickupRequested", highlightedItem)
		highlightedItem = null
		yield(get_tree().create_timer(0.01), "timeout")
		updateHighlight()

func cycleSelectedItem():
	if itemsInRange.size() == 0: return
	itemsInRange.push_back(itemsInRange.pop_front())
	updateHighlight()

func updateHighlight():
	# remove highlighting from current highlightedItem if it's no longer first in line
	if highlightedItem and (itemsInRange.size() == 0 or highlightedItem != itemsInRange[0]):
		if highlightedItem.has_method('removeItemSelectedHighlight'): 
			print('removing highlight from ', highlightedItem.name)
			highlightedItem.removeItemSelectedHighlight()
	
	# if there are no items in range, clear highlightedItem
	if itemsInRange.size() == 0: highlightedItem = null
	# if first item in line isn't highlighted already, highlight it
	elif itemsInRange.size() > 0 and highlightedItem != itemsInRange[0]:
		highlightedItem = itemsInRange[0]
		var itemOwner = highlightedItem.get_parent()
		itemOwner.move_child(highlightedItem, itemOwner.get_child_count())
		if highlightedItem.has_method('addItemSelectedHighlight'):
			print('adding highlight to ', highlightedItem.name) 
			highlightedItem.addItemSelectedHighlight()

func _on_ItemDetector_area_entered(area):
	print('something entered itemdetector: ', area)
	var item = area.get_parent()
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
