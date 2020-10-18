tool
extends Node2D

export(Color) var backgroundColor setget setBackgroundColor
export(Vector2) var rectSize = Vector2(50, 50) setget setRectSize

onready var label:Label = $Label
var timer:Timer

func _ready():
	$Label.text = get_parent().name
	$ColorRect.color = backgroundColor
	$ColorRect.rect_size = rectSize
	setRectSize(rectSize)
	
func _process(_delta):
	if Engine.editor_hint && label && self.name != label.text:
		label.text = self.name

func setBackgroundColor(newColor:Color):
	if backgroundColor != newColor:
		backgroundColor = newColor
		if has_node("ColorRect") && backgroundColor != null: 
			$ColorRect.color = backgroundColor
			$ColorRect.update()

func setRectSize(newRectSize:Vector2):
	rectSize = newRectSize
	if $ColorRect:
		$ColorRect.rect_size = rectSize
