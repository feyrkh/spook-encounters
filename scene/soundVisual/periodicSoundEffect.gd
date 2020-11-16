extends Node2D

export(String) var soundText
export(float) var soundVolume = 50
export(Color) var soundColor = Color.white
export(float) var soundTimeout = 5
export(float) var soundRandomTimeout = 0.5

func _ready():
	$Timer.start(soundTimeout + rand_range(-soundRandomTimeout, soundRandomTimeout))

func _on_Timer_timeout():
	var soundOpts = {
		'sfx': null,
		'msg': soundText, 
		'vol': soundVolume, 
		'pos': self.global_position,
		'color': soundColor
	}
	$"/root/EventBus".emit_signal('soundEffect', soundOpts)
	$Timer.start(soundTimeout + rand_range(-soundRandomTimeout, soundRandomTimeout))
