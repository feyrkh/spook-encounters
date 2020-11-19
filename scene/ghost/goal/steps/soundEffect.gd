extends ScriptStep

export(String) var soundText
export(float) var soundVolume = 50
export(Color) var soundColor = Color.white
export(String) var targetNodePathFromGhost = '.'

func startStep():
	.startStep()
	var soundOpts = {
		'sfx': null,
		'msg': soundText, 
		'vol': soundVolume, 
		'pos': ghost.get_node(targetNodePathFromGhost).global_position,
		'color': soundColor
	}
	$"/root/EventBus".emit_signal('soundEffect', soundOpts)
	emit_signal("stepComplete")
