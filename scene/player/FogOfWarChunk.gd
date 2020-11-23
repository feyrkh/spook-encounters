extends ColorRect

onready var defaultAlpha = self.color.a
var alphaTarget = 1
var curAlpha = 1
export(float) var alphaChangePerSecond = 0.1

func _process(delta):
	if alphaTarget == curAlpha: return
	
	if alphaTarget < curAlpha:
		curAlpha = max(alphaTarget, curAlpha - (delta*alphaChangePerSecond))
	elif alphaTarget > curAlpha:
		curAlpha = min(alphaTarget, curAlpha + (delta*alphaChangePerSecond))
	
	self.color.a = alphaTarget * defaultAlpha
	print('changing alpha to ', self.color.a)

func _on_BrightLightDetector_onEnterBrightLight():
	alphaTarget = 0

func _on_BrightLightDetector_onLeaveBrightLight():
	alphaTarget = 1
