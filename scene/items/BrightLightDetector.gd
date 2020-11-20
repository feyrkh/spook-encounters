extends Area2D

signal onEnterBrightLight # (brightLightArea)
signal onLeaveBrightLight # (brightLightArea)

func _on_BrightLightDetector_area_entered(area):
	emit_signal("onEnterBrightLight", area)


func _on_BrightLightDetector_area_exited(area):
	emit_signal("onLeaveBrightLight", area)
