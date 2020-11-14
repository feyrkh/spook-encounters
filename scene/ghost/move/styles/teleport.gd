extends MovementController

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
		controller.global_position = controller.global_position + Vector2(rand_range(-shakeOffset, shakeOffset), rand_range(-shakeOffset, shakeOffset))
		$ShakeTicker.start()
		yield($ShakeTicker, "timeout")
	emit_signal("shakeComplete")
		
func startTeleport():
	teleporting = true
	startPosition = controller.global_position
	startVisibility = controller.visible
	shake()
	yield(self, 'shakeComplete')
	controller.visible = false
	controller.global_position = moveTarget.global_position
	$HideTimer.start()
	yield($HideTimer, "timeout")
	controller.visible = startVisibility
	shake()
	yield(self, 'shakeComplete')
	teleporting = false
	controller.onMoveFinished(moveTarget)
	moveTarget = null
