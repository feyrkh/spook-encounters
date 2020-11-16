extends Node2D

const SOUND_SATURATION_MAX = 150

var soundScene = preload("res://scene/soundVisual/SoundPopup.tscn") 
var player:Node2D
var soundSaturation = 0
export(float) var soundSaturationDecayRate = 0.95
export(float) var volumeReductionPerHundredPixels = 5
export(float) var maxDistanceToRenderSounds = 300
export(float) var soundSaturationRate = 0.2

func _ready():
	$'/root/EventBus'.connect('soundEffect', self, 'hearSoundEffect')
	player = self.get_parent()

func hearSoundEffect(opts):
	var popup = soundScene.instance()
	var msg = opts.msg
	var position:Vector2 = opts.pos
	# Adjust volume based on distance
	var dist = global_position.distance_to(position)
	var volume = opts.vol - (dist/100) * volumeReductionPerHundredPixels
	if volume <= 0:
		print('inaudible sound: ', msg, '; dist: ', dist, '; vol: ', volume)
		return
	# Adjust visibility based on saturation
	var colorAlpha
	if soundSaturation <= 0: colorAlpha = 1.0
	else: colorAlpha = max(0, 1.0 - (soundSaturation / volume))
	if colorAlpha <= 0:
		print('saturated sound: ', msg, '; dist: ', dist, '; vol: ', volume, '; saturation: ', soundSaturation)
		return

	var color = Color(opts.color.r, opts.color.g, opts.color.b, colorAlpha)	
	var renderPoint = (position - self.global_position).clamped(maxDistanceToRenderSounds) + self.global_position
	soundSaturation = min(SOUND_SATURATION_MAX, soundSaturation + volume*soundSaturationRate)
	popup.global_position = renderPoint
	popup.setup(msg, volume, color)
	player.get_parent().add_child(popup)


func _on_Timer_timeout():
	# Make sound saturation decay periodically
	soundSaturation = max(0, soundSaturation * soundSaturationDecayRate)
	$Label.text = 'Ear: '+str(round(soundSaturation))
