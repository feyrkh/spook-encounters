extends Node

func onDrainPower(controller:GhostController, drainTarget):
	# Drain 20% of the target, or 0.1 energy, whichever is larger. Don't drain more than the target actually has, though.
	var drainedAmt = min(max(0.1, drainTarget.curPower * 0.2), drainTarget.curPower)
	controller.curPower += drainedAmt
	drainTarget.curPower -= drainedAmt
	print("draining ", drainTarget.name, " of ", drainedAmt)
	yield(get_tree().create_timer(2.0), "timeout")
	print("done draining, tell the controller to pick a new goal")
	controller.goal = GhostController.GOAL_THINK
