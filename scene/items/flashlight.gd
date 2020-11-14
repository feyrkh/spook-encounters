extends BasicItem

export(Texture) var itemSlotIconTextureEnabled
export(Texture) var itemSlotIconTextureDisabled

func _ready():
	updateItemSlotIcon()

func onUseItem():
	$Light2D.visible = !$Light2D.visible
	updateItemSlotIcon()
	
func updateItemSlotIcon():
	if $Light2D.visible:
		itemSlotIconTexture = itemSlotIconTextureEnabled
	else:
		itemSlotIconTexture = itemSlotIconTextureDisabled
	$"/root/EventBus".emit_signal('inventoryIconsNeedUpdate')
