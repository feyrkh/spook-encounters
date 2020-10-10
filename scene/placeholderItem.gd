tool
extends Node2D

export(Color) var backgroundColor setget setBackgroundColor
export(Vector2) var rectSize = Vector2(50, 50) 

onready var label:Label = $Label
var timer:Timer

func _ready():
	$Label.text = name
	$ColorRect.color = backgroundColor
	$ColorRect.rect_size = rectSize
	setRectSize(rectSize)
	
func _process(_delta):
	if Engine.editor_hint && label && self.name != label.text:
		label.text = self.name

func _on_ColorRect_item_rect_changed():
	var collider:CollisionShape2D = $RigidBody2D/CollisionShape2D
	collider.shape.extents = $ColorRect.get_rect().size/2
	$RigidBody2D.position = Vector2($ColorRect.get_rect().size.x/2, $ColorRect.get_rect().size.y/2)

func setBackgroundColor(newColor:Color):
	if backgroundColor != newColor:
		backgroundColor = newColor
		if $ColorRect && backgroundColor: 
			$ColorRect.color = backgroundColor
			$ColorRect.update()

func setRectSize(newRectSize:Vector2):
	rectSize = newRectSize
	if $ColorRect:
		$ColorRect.rect_size = rectSize
