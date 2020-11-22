extends Node2D

onready var EventBus = $"/root/EventBus"

var currentlyVisible = false
var hidingFromLightCondition = false
var isBrightlyIlluminated = false
var lightAlphaTarget = 1
var currentLightAlpha = 1

export(float) var lightAlphaChangePerSecond = 3.0 # if 1.0 takes 1 second to go from invisible to visible; 2.0 takes 1/2 second; 3.0 takes 1/3 second; etc
export(bool) var hidesInBrightLight = false
export(bool) var hidesInLowLight = false

func _ready():
	EventBus.connect("visualModeChange", self, 'onVisualModeChange')
	if hidesInBrightLight && hidesInLowLight: hidesInLowLight = false
	if !hidesInBrightLight && !hidesInLowLight: if $BrightLightDetector: $BrightLightDetector.queue_free()
	updateVisuals(EventBus.currentVisualMode)
	
func _process(_delta):
	if lightAlphaTarget < currentLightAlpha:
		currentLightAlpha = max(lightAlphaTarget, currentLightAlpha - (_delta*lightAlphaChangePerSecond))
	elif lightAlphaTarget > currentLightAlpha:
		currentLightAlpha = min(lightAlphaTarget, currentLightAlpha + (_delta*lightAlphaChangePerSecond))
	self.modulate.a = currentLightAlpha

func onVisualModeChange(newMode, itemCausingChange):
	updateVisuals(newMode)
	
func updateVisuals(newMode):
	hidingFromLightCondition = (hidesInBrightLight && isBrightlyIlluminated) || (hidesInLowLight && !isBrightlyIlluminated)
	if hidingFromLightCondition: lightAlphaTarget = 0
	else: lightAlphaTarget = 1
	print('hiding from light/dark=', hidingFromLightCondition, ' for ', get_parent().get_name(), ' with bright lights: ', isBrightlyIlluminated, ' and hidesInLowLight=', hidesInLowLight, '; hidesInBrightLight=', hidesInBrightLight)
	newMode = newMode.to_lower()
	for child in get_children():
		child.visible = newMode in child.name.to_lower()

func _on_BrightLightDetector_onEnterBrightLight():
	print('entered bright light: ', get_parent().get_name())
	#currentBrightLightAreas.append(brightLightArea)
	isBrightlyIlluminated = true
	updateVisuals(EventBus.currentVisualMode)


func _on_BrightLightDetector_onLeaveBrightLight():
	print('left a bright light: ', get_parent().get_name())
	#currentBrightLightAreas.erase(brightLightArea)
	isBrightlyIlluminated = false
	updateVisuals(EventBus.currentVisualMode)
