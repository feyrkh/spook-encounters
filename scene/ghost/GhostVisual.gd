extends Node2D

onready var EventBus = $"/root/EventBus"

var currentlyVisible = false
var hidingFromLightCondition = false

export(bool) var hidesInBrightLight = false
export(bool) var hidesInLowLight = false

func _ready():
	EventBus.connect("visualModeChange", self, 'onVisualModeChange')
	if hidesInBrightLight && hidesInLowLight: hidesInLowLight = false
	onLeaveBrightLight()

func onVisualModeChange(newMode, itemCausingChange):
	updateVisuals(newMode)
	
func updateVisuals(newMode):
	newMode = newMode.to_lower()
	for child in get_children():
		child.visible = !hidingFromLightCondition && newMode in child.name.to_lower()

func onEnterBrightLight():
	hidingFromLightCondition = hidesInBrightLight
	updateVisuals(EventBus.currentVisualMode)

func onLeaveBrightLight():
	hidingFromLightCondition = hidesInLowLight
	updateVisuals(EventBus.currentVisualMode)
