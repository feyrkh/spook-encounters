extends Node
class_name ScriptStep

signal stepComplete

var ghost:ScriptedGhost
var ghostScript
export var stepTimeout:int = 30 # How many seconds to wait for this step to complete before assuming it failed and killing it

func setGhost(_ghost:ScriptedGhost):
	ghost = _ghost
	
func setScript(_script):
	ghostScript = _script

func startStep():
	set_process(true) # Override this in step implementations

func stopStep():
	set_process(false) # Override this in step implementations, if you need to make a step stop running
