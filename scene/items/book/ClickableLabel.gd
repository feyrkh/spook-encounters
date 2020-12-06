extends Label

const itemSelectedMaterial:Material = preload("res://shaders/itemSelectedMaterial.tres")


func _on_Label_mouse_entered():
	add_color_override("font_color", Color.yellow)

func _on_Label_mouse_exited():
	self.add_color_override("font_color", Color.black)
