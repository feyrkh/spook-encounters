extends ScriptStep

export(float) var waitForSeconds
var remainingWait

func _ready():
	stepTimeout = int(waitForSeconds)+1

func _process(delta:float):
	remainingWait -= delta
	if remainingWait <= 0:
		print('wait for ', waitForSeconds, ' complete')
		emit_signal('stepComplete')

func startStep():
	.startStep()
	remainingWait = waitForSeconds
	print('waiting for ', waitForSeconds)


