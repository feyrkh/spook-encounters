extends Node
class_name GhostScript

func _ready():
	for child in get_children():
		if child.has_method('setGhost'): child.setGhost(get_parent())
		if child.has_method('setScript'): child.setScript(self)

