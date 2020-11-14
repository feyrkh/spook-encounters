extends BasicItem

onready var startingBrightness = $Light2D2.energy
const maxBrightnessDiff = 0.1

func onLightWithFire():
	$Light2D2.visible = true

func onUseItemWithEmptyHand():
	putOut()

func onUseItem():
	putOut()
	
func putOut():
	$Light2D2.visible = false


func _on_Timer_timeout():
	if $Light2D2.visible:
		$Light2D2.energy = startingBrightness + rand_range(-maxBrightnessDiff, maxBrightnessDiff)
