extends ScriptStep

export(String) var soundText
export(float) var soundVolume = 50
export(Color) var soundColor = Color.white
export(String) var targetNodePathFromGhost = '..'
var scene = preload("res://scene/soundVisual/SoundPopup.tscn") 

func startStep():
	.startStep()
	var popup = scene.instance()
	popup.global_position = ghost.global_position
	popup.setup(soundText, soundVolume, soundColor)
	ghost.get_node(targetNodePathFromGhost).add_child(popup)
	emit_signal("stepComplete")
