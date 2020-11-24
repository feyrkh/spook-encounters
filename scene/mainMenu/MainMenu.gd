extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	if Input.is_action_just_released("use_item"):
		get_tree().change_scene("res://levels/Tutorial.tscn")
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
