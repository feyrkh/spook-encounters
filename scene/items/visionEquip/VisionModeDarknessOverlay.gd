extends CanvasModulate

onready var EventBus = $'/root/EventBus'

onready var defaultColor = self.color
export(Color) var nightVisionColor = Color.darkgray

func _ready():
	EventBus.connect("visualModeChange", self, 'onVisualModeChange')

func onVisualModeChange(modeName, changingItem):
	match modeName: 
		'nightVision': self.color = nightVisionColor
		_: self.color = defaultColor
