extends Node

signal inventoryIconsNeedUpdate # an item in your inventory has changed and you should update your images
signal soundEffect # {sfx:FilePathString, msg:String, vol:int [1-100], pos:Vector2, color:Color)
signal visualModeChange # (visualModeName, itemCausingChange)

var currentVisualMode = "default"
var itemCausingVisualMode = null

func _on_EventBus_visualModeChange(visualModeName, itemCausingChange):
	currentVisualMode = visualModeName
	if visualModeName == "default": itemCausingVisualMode = null
	else: itemCausingVisualMode = itemCausingChange
