extends Node2D

func _ready():
	$"/root/EventBus".connect("visualModeChange", self, 'onVisualModeChange')

func onVisualModeChange(modeName, itemMakingChange):
	for child in get_children(): child.visible = false
	var overlay = self.get_node_or_null(modeName)
	if overlay:
		overlay.visible = true
