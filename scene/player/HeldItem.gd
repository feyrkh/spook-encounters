extends Node2D

# See also MouseRotationPlayerController.gd
enum {None, Left, DownLeft, Down, DownRight, Right, UpRight, Up, UpLeft}
var facing = None

func _on_MoveController_facingChange(oldFacing, newFacing):
	facing = newFacing
	var oldAttach:Node2D = getAttachPoint(oldFacing)
	if !oldAttach: return
	if oldAttach.get_child_count() == 0: return
	var newAttach:Node2D = getAttachPoint(newFacing)
	if !newAttach: return
	for child in oldAttach.get_children():
		oldAttach.remove_child(child)
		newAttach.add_child(child)

func getAttachPoint(facing):
	match facing:
		Left: return $Left
		DownLeft: return $DownLeft
		UpLeft: return $UpLeft
		Right: return $Right
		DownRight: return $DownRight
		UpRight: return $UpRight
		Up: return $Up
		Down: return $Down
