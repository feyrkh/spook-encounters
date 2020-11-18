extends BasicItem
class_name AbstractVisionEquip

export(Texture) var itemSlotIconTextureEnabled
export(Texture) var itemSlotIconTextureDisabled
export(bool) var disableOnUnequip = true
export(String) var visualModeName = 'default'
onready var EventBus = $'/root/EventBus'
var changingMode = false

var enabled = false

func _ready():
	updateItemSlotIcon()
	EventBus.connect("visualModeChange", self, 'onVisualModeChange')

func onUseItem():
	if enabled: turnVisionModeOff()
	else: turnVisionModeOn()

func turnVisionModeOn():
	changingMode = true
	enabled = true
	EventBus.emit_signal('visualModeChange', visualModeName, self)
	updateItemSlotIcon()
	changingMode = false

func turnVisionModeOff():
	changingMode = true
	enabled = false
	EventBus.emit_signal('visualModeChange', 'default', self)
	updateItemSlotIcon()
	changingMode = false

func updateItemSlotIcon():
	if enabled:
		itemSlotIconTexture = itemSlotIconTextureEnabled
	else:
		itemSlotIconTexture = itemSlotIconTextureDisabled
	EventBus.emit_signal('inventoryIconsNeedUpdate')

func onVisualModeChange(visionModeName, itemCausingChange):
	if itemCausingChange == self || changingMode: return
	if enabled:
		turnVisionModeOff()

func onDrop():
	turnVisionModeOff()
	.onDrop()

func onUnequip():
	if disableOnUnequip: turnVisionModeOff()
