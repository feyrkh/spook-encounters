extends Node2D

signal noRoomForNewItem
signal pickupNotAllowed # (item)
signal itemUnequipped # (item)
signal itemEquipped # (item)

export(NodePath) var itemHolderPath
export(NodePath) var itemDetectorPath
export(NodePath) var playerPath
var player
var itemHolder:HeldItem
var itemDetector:ItemDetector
onready var equippedItemLabel:Label = get_node("EquippedItemLabel")
var emptyHandItem
var invSlots = [null, null, null, null, null, null, null, null, null] # Actual objects that are held - not to be confused with their placeholder images
var equippedItem = null
var playerClickControls = true

func _ready():
	emptyHandItem = find_node("EmptyHandItem", true)
	itemHolder = get_node(itemHolderPath)
	itemDetector = get_node(itemDetectorPath)
	player = get_node(playerPath)
	#connect("itemEquipped", itemHolder, 'onItemEquipped')
	updateAllInvSlotImages()
	$"/root/EventBus".connect('inventoryIconsNeedUpdate', self, 'updateAllInvSlotImages')
	$"/root/EventBus".connect('disablePlayerClickControls', self, 'disablePlayerClickControls')
	$"/root/EventBus".connect('enablePlayerClickControls', self, 'enablePlayerClickControls')
	EventBus.connect("enteredRoom", self, 'onEnterRoom')
	EventBus.connect("exitedRoom", self, 'onExitRoom')

var enteredRooms = []
func onEnterRoom(roomName):
	print('entered room: ', roomName)
	enteredRooms.append(roomName)
	find_node('RoomNameLabel').text = enteredRooms[-1]

func onExitRoom(roomName):
	print('exited room: ', roomName)
	enteredRooms.erase(roomName)
	var bestName = ''
	if enteredRooms.size() > 0: bestName = enteredRooms[-1]
	find_node('RoomNameLabel').text = bestName

func enablePlayerClickControls():
	playerClickControls = true

func disablePlayerClickControls():
	playerClickControls = false

func updateAllInvSlotImages():
	for i in range(invSlots.size()):
		updateInvSlotImage(i)

func _process(delta):
	if playerClickControls && Input.is_action_just_pressed('use_item'):
		useEquippedItem(true)
	elif playerClickControls && Input.is_action_just_pressed("use_item_alternate"):
		useEquippedItem(false)
	if Input.is_action_just_released('next_item'):
		switchToNextItem(1)
	if Input.is_action_just_released('prev_item'):
		switchToNextItem(-1)
	if Input.is_action_just_pressed('drop_held_item'):
		onItemDropRequested(equippedItem)
	if Input.is_action_just_pressed("inv_select_0"):
		switchToItem(-1)
	if Input.is_action_just_pressed("inv_select_1"):
		switchToItem(0)
	if Input.is_action_just_pressed("inv_select_2"):
		switchToItem(1)
	if Input.is_action_just_pressed("inv_select_3"):
		switchToItem(2)
	if Input.is_action_just_pressed("inv_select_4"):
		switchToItem(3)
	if Input.is_action_just_pressed("inv_select_5"):
		switchToItem(4)
	if Input.is_action_just_pressed("inv_select_6"):
		switchToItem(5)
	if Input.is_action_just_pressed("inv_select_7"):
		switchToItem(6)
	if Input.is_action_just_pressed("inv_select_8"):
		switchToItem(7)
	if Input.is_action_just_pressed("inv_select_9"):
		switchToItem(8)

func useEquippedItem(primaryClick):
	if equippedItem == null && itemDetector.highlightedItem: 
		if primaryClick && itemDetector.highlightedItem.has_method('onUseItemWithEmptyHand'):
			itemDetector.highlightedItem.onUseItemWithEmptyHand(player)
		elif !primaryClick && itemDetector.highlightedItem.has_method('onAlternateUseItemWithEmptyHand'):
			itemDetector.highlightedItem.onAlternateUseItemWithEmptyHand(player)
	elif equippedItem != null:
		if primaryClick && itemDetector.highlightedItem && equippedItem.has_method('onUseItemOnTarget'):
			equippedItem.onUseItemOnTarget(itemDetector.highlightedItem, player)		
		elif !primaryClick && itemDetector.highlightedItem && equippedItem.has_method('onAlternateUseItemOnTarget'):
			equippedItem.onAlternateUseItemOnTarget(itemDetector.highlightedItem, player)
		elif primaryClick && equippedItem.has_method('onUseItem'):
			equippedItem.onUseItem(player)
		elif !primaryClick && equippedItem.has_method('onAlternateUseItem'):
			equippedItem.onAlternateUseItem(player)
		
func isRoomForNewItem():
	for invSlot in invSlots:
		if invSlot == null: return true
	return false
	
func pickupNewItem(newItem):
	if newItem == null: return
	var newItemSlot
	for i in range(invSlots.size()):
		if invSlots[i] == null: 
			newItemSlot=i
			break
	invSlots[newItemSlot] = newItem
	newItem.isHeld = true
	if newItem.has_method('onPickup'): newItem.onPickup()
	if equippedItem == null:
		setEquippedItem(newItem)
	else: 
		putItemInBag(newItem)
	updateInvSlotImage(newItemSlot)

func updateInvSlotImage(itemSlotIdx):
	var itemFrame = $ItemFrames.get_child(itemSlotIdx)
	if invSlots[itemSlotIdx] == null:
		itemFrame.get_node('ItemIcon').visible = false
		itemFrame.modulate = Color.gray
	else:
		if invSlots[itemSlotIdx] == equippedItem: itemFrame.modulate = Color.white
		else: itemFrame.modulate = Color.gray
		itemFrame.get_node('ItemIcon').visible = true
		var icon = invSlots[itemSlotIdx].itemSlotIconTexture
		if icon:
			itemFrame.get_node('ItemIcon').texture = icon

func onItemPickupRequested(highlightedItem):
	if highlightedItem && !highlightedItem.canBePickedUp:
		if highlightedItem.has_method('interactWithStationaryItem'):
			highlightedItem.interactWithStationaryItem(player)
		else:
			emit_signal("pickupNotAllowed", highlightedItem)
	if !isRoomForNewItem():
		emit_signal("noRoomForNewItem")
		return
	pickupNewItem(highlightedItem)

func onItemDropRequested(heldItem):
	if heldItem:
		if itemHolder.dropItem():
			for i in range(invSlots.size()):
				if invSlots[i] == heldItem:
					invSlots[i] = null
					updateInvSlotImage(i)
			equippedItem = null
			

func setEquippedItem(newItem):
	if equippedItem == newItem: return
	if equippedItem:
		emit_signal("itemUnequipped", equippedItem)
		itemHolder.unholdItem()
	equippedItem = newItem
	var itemName = ''
	if newItem:
		itemHolder.holdItem(equippedItem)
		emit_signal("itemEquipped", equippedItem)
		itemName = newItem.itemImageName
	equippedItemLabel.text = itemName
	updateAllInvSlotImages()

func putItemInBag(item):
	if item == null: return
	item.visible = false
	item.get_parent().remove_child(item)
	add_child(item)
	item.position = Vector2.ZERO
	if item == equippedItem:
		setEquippedItem(null)
	updateAllInvSlotImages()

func getEquippedItemSlot():
	if equippedItem == null: return -1
	for i in range(invSlots.size()):
		if invSlots[i] != null && invSlots[i] == equippedItem:
			return i
	return -1

func switchToItem(itemIndex):
	if itemIndex < 0 || itemIndex >= invSlots.size():
		putItemInBag(equippedItem)
		return
	setEquippedItem(invSlots[itemIndex])

func switchToNextItem(direction):
	var origSlot = getEquippedItemSlot()
	var curSlot = (origSlot + direction) % (invSlots.size() + 1)
	var slotTries = invSlots.size()+1
	while curSlot != origSlot:
		slotTries -= 1
		if slotTries < 0: return
		if curSlot < 0: curSlot += invSlots.size() + 1
		if curSlot >= invSlots.size(): 
			if equippedItem:
				# We wrapped around the end of the list, unequip the item instead
				putItemInBag(equippedItem)
				return
			elif origSlot == -1:
				# We started with an unequipped item, just keep going rather than unequipping 
				curSlot = (curSlot + direction) % (invSlots.size() + 1)
			else: 
				# We must not have any items at all, just stop here
				return
		if invSlots[curSlot] != null:
			setEquippedItem(invSlots[curSlot])
			return
		curSlot = (curSlot + direction) % (invSlots.size() + 1)
	# If we didn't switch items then we only had the one item
