extends Area2D


func _on_RoomDetector_area_entered(area):
	var areaParent = area.get_parent()
	EventBus.emit_signal('enteredRoom', areaParent.roomName)


func _on_RoomDetector_area_exited(area):
	var areaParent = area.get_parent()
	EventBus.emit_signal('exitedRoom', areaParent.roomName)
