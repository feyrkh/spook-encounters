extends Node2D

var player

func _process(delta):
	self.global_rotation = 0

func _on_ColorRect_mouse_entered():
	$"/root/EventBus".emit_signal('disablePlayerClickControls')


func _on_ColorRect_mouse_exited():
	$"/root/EventBus".emit_signal('enablePlayerClickControls')
