extends MoveStyle

var teleporting = false
var startPosition
var startVisibility
export var shakeOffset = 10

signal shakeComplete

func _process(_delta):
	if (!moveTarget || teleporting): return
	startTeleport()

func shake():
	$ShakeTimer.start()
	while($ShakeTimer.time_left > 0):
		body.global_position = body.global_position + Vector2(rand_range(-shakeOffset, shakeOffset), rand_range(-shakeOffset, shakeOffset))
		$ShakeTicker.start()
		yield($ShakeTicker, "timeout")
	emit_signal("shakeComplete")
		
func startTeleport():
	teleporting = true
	startPosition = body.global_position
	startVisibility = body.visible
	shake()
	yield(self, 'shakeComplete')
	body.visible = false
	body.global_position = moveTarget.global_position
	$HideTimer.start()
	yield($HideTimer, "timeout")
	body.visible = startVisibility
	shake()
	yield(self, 'shakeComplete')
	teleporting = false
	body.onMoveFinished(moveTarget)
	moveTarget = null
