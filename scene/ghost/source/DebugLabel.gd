extends Label

func _on_powerSource_curPowerUpdated(powerSource, oldCurPower, newCurPower):
	text = powerSource.name + ": " + str(round(newCurPower*10)/10)
