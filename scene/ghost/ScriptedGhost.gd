extends KinematicBody2D
class_name ScriptedGhost

func _ready():
	randomize()
	move_script_commands()

func move_script_commands():
	var realScriptContainer = find_node('GhostScript', true)
	var instanceScriptContainer = find_node('script', false)
	if !instanceScriptContainer: return
	for child in instanceScriptContainer.get_children():
		instanceScriptContainer.remove_child(child)
		realScriptContainer.add_child(child)

