extends Node
class_name PowerSourceUtil


static func calculatePowerSourceBitmask(entity):
	var result = 0
	if entity.humanSource: result |= 1
	if entity.electricalSource: result |= 1<<1
	if entity.thermalSource: result |= 1<<2
	if entity.ritualSource: result |= 1<<3
	if entity.spiritLinkSource: result |= 1<<4
	if entity.angerSource: result |= 1<<5
	if entity.fearSource: result |= 1<<6
	if entity.calmSource: result |= 1<<7
	if entity.noiseSource: result |= 1<<8
	
	print("power source bitmask for ", entity.name, ": ", result)
	return result
