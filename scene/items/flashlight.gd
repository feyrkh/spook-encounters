extends BasicItem

export(Texture) var itemSlotIconTextureEnabled
export(Texture) var itemSlotIconTextureDisabled

func _ready():
	updateItemSlotIcon()
	
func onUseItem():
	$Light2D.visible = !$Light2D.visible
	if $BrightLightArea: 
		# Trick to get the bright light area to recalculate
		$BrightLightArea.position.x += 0.01
		$BrightLightArea.position.x -= 0.01
		
	updateItemSlotIcon()
	

func onUseItemWithEmptyHand():
	onUseItem()
	
func updateItemSlotIcon():
	if get_node_or_null('BrightLightArea'): $BrightLightArea.monitorable = $Light2D.visible
	if $Light2D.visible:
		itemSlotIconTexture = itemSlotIconTextureEnabled
	else:
		itemSlotIconTexture = itemSlotIconTextureDisabled
	$"/root/EventBus".emit_signal('inventoryIconsNeedUpdate')
