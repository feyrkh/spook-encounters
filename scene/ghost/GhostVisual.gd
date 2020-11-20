extends Node2D

onready var EventBus = $"/root/EventBus"

var currentlyVisible = false
var hidingFromLightCondition = false
var currentBrightLightAreas = []

export(bool) var hidesInBrightLight = false
export(bool) var hidesInLowLight = false

func _ready():
	EventBus.connect("visualModeChange", self, 'onVisualModeChange')
	if hidesInBrightLight && hidesInLowLight: hidesInLowLight = false
	if !hidesInBrightLight && !hidesInLowLight: if $BrightLightDetector: $BrightLightDetector.queue_free()
	updateVisuals(EventBus.currentVisualMode)
	
func onVisualModeChange(newMode, itemCausingChange):
	updateVisuals(newMode)
	
func updateVisuals(newMode):
	hidingFromLightCondition = (hidesInBrightLight && currentBrightLightAreas.size() > 0) || (hidesInLowLight && currentBrightLightAreas.size() == 0)
	print('hiding from light/dark=', hidingFromLightCondition, ' for ', get_parent().get_name(), ' with bright lights: ', currentBrightLightAreas.size(), ' and hidesInLowLight=', hidesInLowLight, '; hidesInBrightLight=', hidesInBrightLight)
	newMode = newMode.to_lower()
	for child in get_children():
		child.visible = !hidingFromLightCondition && newMode in child.name.to_lower()

func _on_BrightLightDetector_onEnterBrightLight(brightLightArea):
	print('entered bright light: ', get_parent().get_name())
	currentBrightLightAreas.append(brightLightArea)
	updateVisuals(EventBus.currentVisualMode)


func _on_BrightLightDetector_onLeaveBrightLight(brightLightArea):
	print('left a bright light: ', get_parent().get_name())
	currentBrightLightAreas.erase(brightLightArea)
	updateVisuals(EventBus.currentVisualMode)
