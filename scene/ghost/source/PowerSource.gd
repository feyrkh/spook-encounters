extends Node2D
class_name PowerSource

signal curPowerUpdated # self, oldAmt, newAmt

export(bool) var humanSource = false      # energy from being near the player
export(bool) var electricalSource = false # flashlights, equipment
export(bool) var thermalSource = false    # candles, furnaces
export(bool) var ritualSource = false     # pentagrams, ouija boards
export(bool) var spiritLinkSource = false # items that are linked to a specific spirit
export(bool) var angerSource = false      # the player, when they say negative things or talk about things the spirit doesn't like
export(bool) var fearSource = false       # the player, when they are getting scared
export(bool) var calmSource = false       # the player, when they say positive things
export(bool) var noiseSource = false      # environmental noises, player talking, bumping into furniture


export(float) var curPower = 0 setget setCurPower
export(float) var maxPower = 10
export(float) var rechargePowerPerSecond = 0.001
export(float) var drainPowerPerMinute = 0.25
var powerSourceBitmask = 0

func _ready():
	powerSourceBitmask = PowerSourceUtil.calculatePowerSourceBitmask(self)
	emit_signal("curPowerUpdated", self, 0, curPower)

func setCurPower(newCurPower):
	var oldCurPower = curPower
	curPower = newCurPower
	emit_signal("curPowerUpdated", self, oldCurPower, newCurPower)
	# subclasses can trigger effects here

func _process(delta):
	setCurPower(clamp(curPower + rechargePowerPerSecond * delta, 0, maxPower))
