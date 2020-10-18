extends Node2D
class_name MovementController

export(float) var movePixelsPerSecond = 40
export(float) var closingDistance = 30 # How far away should be before stopping
var moveTarget:Node2D
var controller:GhostController

func onMoveToGoal(ghost:GhostController, newMoveTarget:Node2D):
	moveTarget = newMoveTarget
	controller = ghost
