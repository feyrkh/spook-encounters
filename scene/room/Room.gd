extends Node2D

export(String) var roomName

func _ready():
	move_items_to_group_parent('Floors', 'FloorParent')
	move_items_to_group_parent('Walls', 'WallParent')
	move_items_to_group_parent('Props', 'ItemLayer')
	move_items_to_group_parent('WallToppers', 'WallTopperParent')
	move_items_to_group_parent('WallCorners', 'WallCornerParent')
	move_items_to_group_parent('NavMesh', 'NavMeshParent')
	
func move_items_to_group_parent(childContainerName, groupParentName):
	var childContainer = find_node(childContainerName, true)
	if !childContainer: 
		printerr('No child container named ', childContainerName, '; not moving any nodes for it')
		return
	var groupParent = get_tree().get_nodes_in_group(groupParentName)
	if groupParent.size() >= 2: printerr('Too many group parents for ', groupParentName, ', you should fix that')
	if groupParent.size() == 0: 
		printerr('Not enough group parents for ', groupParentName, ', you should fix that; not moving any nodes for ', childContainerName)
		return
	groupParent = groupParent[0]
	for child in childContainer.get_children():
		var child_global_pos
		if child is Node2D: child_global_pos = child.global_position
		elif child is Control: child_global_pos = child.rect_global_position
		childContainer.remove_child(child)
		groupParent.add_child(child)
		groupParent.move_child(child, 0)
		if child is Node2D: child.global_position = child_global_pos
		elif child is Control: child.rect_global_position = child_global_pos
	
	
