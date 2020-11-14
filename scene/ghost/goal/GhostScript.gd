extends Node
class_name GhostScript

var scriptStepIdx = -1
var stepRunning:ScriptStep
var stepForceStopAt:int

func _ready():
	for child in get_children():
		child.setGhost(get_parent())
		child.setScript(self)
		child.set_process(false)

func updateSteps():
	if stepRunning:
		# Check to see if the step timed out and move on if so
		if OS.get_unix_time() >= stepForceStopAt:
			print('Time to force-stop the step: ', OS.get_unix_time(), ' >= ', stepForceStopAt)
			stepRunning.stopStep()
	else:
		nextStep()
			

func nextStep():
	scriptStepIdx = (scriptStepIdx + 1) % get_child_count()
	print('nextStep(',scriptStepIdx,'): ', get_child(scriptStepIdx).name)
	disconnectStepListener()
	if stepRunning && stepRunning.is_processing():
		print('step still running, force-stopping now')
		stepRunning.stopStep()
	stepRunning = get_child(scriptStepIdx)
	connectStepListener()
	# start the timer
	stepForceStopAt = OS.get_unix_time() + stepRunning.stepTimeout
	# start the step
	stepRunning.startStep()

func connectStepListener():
	stepRunning.connect('stepComplete', self, 'stepComplete')
	#print('connecting listener: ', stepRunning)

func disconnectStepListener():
	if stepRunning && stepRunning.is_connected('stepComplete', self, 'stepComplete'):
		stepRunning.disconnect('stepComplete', self, 'stepComplete')
		#print('disconnecting listener: ', stepRunning)

func stepComplete():
	print('stepComplete()')
	disconnectStepListener()
	if stepRunning: stepRunning.stopStep()
	stepRunning = null
