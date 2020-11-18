extends Light2D
class_name VisualModeAffectedLight

export(float) var nightVisionMultiplier = 4
onready var EventBus = $"/root/EventBus"
onready var defaultEnergy = self.energy

func _ready():
	EventBus.connect("visualModeChange", self, 'onVisualModeChange')

func onVisualModeChange(modeName, changingItem):
	match modeName:
		'nightVision': 
			self.energy = nightVisionMultiplier * defaultEnergy
		_: self.energy = defaultEnergy
