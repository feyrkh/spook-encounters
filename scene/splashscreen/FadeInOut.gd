extends Node

export var fadeInSeconds = 0.25
export var lingerSeconds = 1
export var fadeOutSeconds = 0.5

func _ready():
	$Overlay.color = Color.black

func _on_StartFadeTimer_timeout():
	print_debug("starting fade in")
	$Tween.interpolate_property($Overlay, "modulate", Color.black, Color(0,0,0,0), fadeInSeconds, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	print_debug("starting linger")
	yield(get_tree().create_timer(lingerSeconds), "timeout")
	$Tween.interpolate_property($Overlay, "modulate", 
		Color(0,0,0,0), Color.black, fadeInSeconds)
	$Tween.start()
	print_debug("starting fade out")
	yield($Tween, "tween_completed")
	yield(get_tree().create_timer(0.25), "timeout")
	get_tree().change_scene("res://scene/mainMenu/MainMenu.tscn")
