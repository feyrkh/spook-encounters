extends BasicItem

var target
var player
var popupOffset

const maxPixelDistanceBeforeClosing = 400
const maxPixelDistanceSquaredBeforeClosing = maxPixelDistanceBeforeClosing*maxPixelDistanceBeforeClosing

onready var bookDialog = $BookDialog

func _process(delta):
	if target:
		bookDialog.global_position = (target.global_position + popupOffset).round()
		var dist = bookDialog.global_position.distance_squared_to(player.position)
		if dist > maxPixelDistanceSquaredBeforeClosing: closeBook(player)

# Called when player presses the 'use' button while holding an item, or looking at an item on the ground
func onUseItem(player):
	if !bookInUseBySomeoneElse(player):
		if !bookDialog.visible:
			openBook(player, player)
		else:
			closeBook(player)

func onUseItemWithEmptyHand(player):
	if !bookInUseBySomeoneElse(player):
		if !bookDialog.visible:
			openBook(player, self)
		else:
			closeBook(player)

func bookInUseBySomeoneElse(player):
	return (bookDialog.player != null) && (bookDialog.player != player)

func openBook(_player, newTarget):
	self.player = _player
	bookDialog.player = player
	var facingAngleRad = deg2rad(player.get_node('MoveController').facingAngle)
	var playerPosition = player.global_position
	print_debug('original popup position: ', bookDialog.global_position)
	var popupPosition = (Vector2(1, 0).rotated(facingAngleRad)).normalized() * max(bookDialog.texture.get_size().x/2, bookDialog.texture.get_size().y/2)
	bookDialog.global_position = playerPosition + popupPosition
	print('facingAngle: ', player.get_node('MoveController').facingAngle)
	print('bookDialog size: ', bookDialog.texture.get_size())
	print('relative popup position: ', popupPosition)
	print('playerPosition: ', playerPosition)
	print('new book position: ', bookDialog.global_position)
	target = newTarget
	popupOffset =  bookDialog.global_position - target.global_position
	print('popupOffset: ', popupOffset)
	bookDialog.visible = true
	set_process(true)
		
func closeBook(player):
	self.player = null
	bookDialog.player = null
	bookDialog.visible = false
	set_process(false)
