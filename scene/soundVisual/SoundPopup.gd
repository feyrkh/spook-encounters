extends Node2D

const FLOAT_TIME = 2

const VOL_SPEECH = 30
const VOL_SHOUT = 60
const VOL_STEP = 10
const VOL_WHISPER = 5

onready var tween:Tween = $Tween

func setup(soundText:String, soundVolume:float = 50, soundColor:Color = Color.white):
	$Label.text = soundText
	$Label.self_modulate = soundColor

func _ready():
	tween.interpolate_property(self, 'position', global_position, global_position - Vector2(0, 50), FLOAT_TIME)
	tween.interpolate_callback(self, FLOAT_TIME, 'queue_free')
	tween.start()
