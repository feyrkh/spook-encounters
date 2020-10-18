extends KinematicBody2D
class_name GhostController

signal thinkOfGoal # self:GhostController; should trigger GoalController to come up with a new goal
signal moveToGoal # self:GhostController, goal:Node2D; should trigger MovementController to move near the goal
signal drainPower # self:GhostController, target:PowerSource; should trigger DrainController to drain power from the target

const GOAL_THINK = "think"
const GOAL_DRAIN_POWER = "drainPower"

export(bool) var humanSource = false      # energy from being near the player
export(bool) var electricalSource = false # flashlights, equipment
export(bool) var thermalSource = false    # candles, furnaces
export(bool) var ritualSource = false     # pentagrams, ouija boards
export(bool) var spiritLinkSource = false # items that are linked to a specific spirit
export(bool) var angerSource = false      # the player, when they say negative things or talk about things the spirit doesn't like
export(bool) var fearSource = false       # the player, when they are getting scared
export(bool) var calmSource = false       # the player, when they say positive things
export(bool) var noiseSource = false      # environmental noises, player talking, bumping into furniture

var curPower = 0

var powerSourceBitmask = 0
var goal = GOAL_THINK setget setGoal
var targetPowerSource

func _ready():
	$GoalTimer.wait_time = rand_range(0.5, 3)
	powerSourceBitmask = PowerSourceUtil.calculatePowerSourceBitmask(self)
	self.connect("moveToGoal", $MovementController, "onMoveToGoal")
	self.connect("drainPower", $DrainController, "onDrainPower")
	self.connect("thinkOfGoal", $GoalController, "onThinkOfGoal")
	yield(get_tree().create_timer(0.1), "timeout")
	emit_signal("thinkOfGoal", self)

# Called by MovementController when a goal is reached, should start the process of
# achieving the goal it was moving toward
func onMoveFinished(_moveTarget:Node2D):
	match goal:
		GOAL_DRAIN_POWER:
			emit_signal("drainPower", self, targetPowerSource)
		_: goal = GOAL_THINK

# When a new goal is chosen, figure out what we need to do to start it - usually
# it will be choosing a target and then moving toward it
func setGoal(var newGoal):
	print("Ghost goal change from ", goal, " to ", newGoal)
	goal = newGoal
	match newGoal:
		GOAL_DRAIN_POWER:
			targetPowerSource = targetNewPowerSource()
			if targetPowerSource:
				emit_signal("moveToGoal", self, targetPowerSource)
		GOAL_THINK:
			pass # We'll wait for the next goal timer tick to come up with a new goal
		_: printerr("Unexpected goal: ", newGoal)

# Find a power source to drain, taking type, power level and distance into account
func targetNewPowerSource():
	var allPowerSources = get_tree().get_nodes_in_group("powerSource")
	var canDrainFrom = []
	for powerSource in allPowerSources:
		if powerSourcesCompatible(powerSource) && powerSource.curPower > 0:
			canDrainFrom.append(powerSource)
	print("Found ", allPowerSources.size(), " power sources, ", canDrainFrom.size(), " of them are compatible with ", self.name)

	if canDrainFrom.size() == 0:
		setGoal(GOAL_THINK)
		return null

	# Find the longest distance so we can scale the available power levels by distance
	var longestDistance = (canDrainFrom[0].position - position).length()
	for powerSource in canDrainFrom:
		var dist = sqrt((powerSource.position - position).length_squared())
		if dist > longestDistance:
			longestDistance = dist
			
	# Calculate a desirability value based on amount of power available, scaled by distance from the ghost (plus a random amount)
	var highestValue = 0
	var bestChoice
	for powerSource in canDrainFrom:
		var distScaling = ((powerSource.position - position).length() / longestDistance) + (randf() * 2)
		var curValue = powerSource.curPower / distScaling
		if curValue > highestValue: 
			highestValue = curValue
			bestChoice = powerSource
	print("Targeting ", bestChoice.name, " for draining.")
	return bestChoice

func powerSourcesCompatible(powerSource):
	return powerSourceBitmask & powerSource.powerSourceBitmask

# Called periodically, if we've finished our previous goal then let's come up with a new one
func _on_GoalTimer_timeout():
	if goal != GOAL_THINK: return
	emit_signal("thinkOfGoal", self)
