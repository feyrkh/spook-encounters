extends Node2D
class_name GoalController

func onThinkOfGoal(controller:GhostController):
	controller.setGoal(GhostController.GOAL_DRAIN_POWER)
