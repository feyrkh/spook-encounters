extends RichTextLabel



func _on_GoalTimer_timeout():
	text = get_parent().name + ": " + str(get_parent().curPower)
