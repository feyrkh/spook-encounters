extends Node2D

# See also HeldItem.gd
enum {None, Left, DownLeft, Down, DownRight, Right, UpRight, Up, UpLeft}

signal facingChange # (oldDirection, newDirection, angleDegrees)
signal updateFacingAngle # (angleDegrees)

const MOVE_BACK_PENALTY = 0.4
const MOVE_SIDE_PENALTY = 0.7
const MOVE_FORWARD_PENALTY = 0.9
const MOVE_STRAIGHT_PENALTY = 1.0

const HALF_SECTOR_DEG = 22.5
const FACE_LEFT_MIN = 180 - HALF_SECTOR_DEG
const FACE_LEFT_MAX = -180 + HALF_SECTOR_DEG
const FACE_DOWN_LEFT_MAX = FACE_LEFT_MIN
const FACE_DOWN_LEFT_MIN = FACE_DOWN_LEFT_MAX - HALF_SECTOR_DEG*2
const FACE_DOWN_MAX = FACE_DOWN_LEFT_MIN
const FACE_DOWN_MIN = FACE_DOWN_MAX - HALF_SECTOR_DEG*2
const FACE_DOWN_RIGHT_MAX = FACE_DOWN_MIN
const FACE_DOWN_RIGHT_MIN = FACE_DOWN_RIGHT_MAX - HALF_SECTOR_DEG*2
const FACE_RIGHT_MAX = FACE_DOWN_RIGHT_MIN
const FACE_RIGHT_MIN = FACE_RIGHT_MAX - HALF_SECTOR_DEG*2
const FACE_UP_RIGHT_MAX = FACE_RIGHT_MIN
const FACE_UP_RIGHT_MIN = FACE_UP_RIGHT_MAX - HALF_SECTOR_DEG*2
const FACE_UP_MAX = FACE_UP_RIGHT_MIN
const FACE_UP_MIN = FACE_UP_MAX - HALF_SECTOR_DEG*2
const FACE_UP_LEFT_MAX = FACE_UP_MIN
const FACE_UP_LEFT_MIN = FACE_UP_LEFT_MAX - HALF_SECTOR_DEG*2

const upVector = Vector2(0, -1)
const downVector = Vector2(0, 1)
const leftVector = Vector2(-1, 0)
const rightVector = Vector2(1, 0)
var upLeftVector = Vector2(-1, -1).normalized()
var upRightVector = Vector2(1, -1).normalized()
var downLeftVector = Vector2(-1, 1).normalized()
var downRightVector = Vector2(1, 1).normalized()
const noneVector = Vector2.ZERO

var animatedSprite:AnimatedSprite

var facing = Right
var facingAngle
var moveDirection = None
export var movePixelsPerSecond = 100
var moveVector:Vector2 = noneVector

export(NodePath) var kinematicBody2DPath
var kinematicBody2D:KinematicBody2D

var pressingLeft = false
var pressingRight = false
var pressingUp = false
var pressingDown = false

var upControl = "p1_move_up"
var downControl = "p1_move_down"
var leftControl = "p1_move_left"
var rightControl = "p1_move_right"

var animation = "moveRight" # Currently playing animation
var playingAnimation = false # True if we are not currently idle
var animateBackward = false # True if we're walking backward and we should reverse the animation
var flipped = false # Is the animation image flipped horizontally
var movingBackwardPenalty = 1.0 # If we're moving in a direction other than the one we're facing, get a penalty. < 1.0 means moving slower than normal

func _ready():
	animatedSprite = get_parent().get_node("AnimatedSprite")
	animatedSprite.play(animation)
	animatedSprite.stop()
	playingAnimation = false
	kinematicBody2D = get_node(kinematicBody2DPath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# TODO: Remove auto-close on escape
	if Input.is_action_just_pressed("ui_cancel"): get_tree().quit()
	updateFacing()
	checkInputs(_delta)
	if moveVector != noneVector:
		moveVector = moveVector.normalized() * movePixelsPerSecond
		moveVector = kinematicBody2D.move_and_slide(moveVector * movingBackwardPenalty)
		#print("Moving: ", moveVector)
		
func isMoving():
	return moveVector != Vector2.ZERO
	
func updateFacing():
	var newFacing = None
	var newFacingAngle = rad2deg(get_angle_to(get_global_mouse_position()))
	if newFacingAngle != facingAngle:
		emit_signal('updateFacingAngle', newFacingAngle)
		facingAngle = newFacingAngle
		if facingAngle >= FACE_LEFT_MIN or facingAngle < FACE_LEFT_MAX: 
			newFacing = Left # or on purpose - "left" straddles from 2pi-1/8pi, then crosses a discontinuity to -2pi+1/8pi
		elif facingAngle >= FACE_DOWN_LEFT_MIN and facingAngle < FACE_DOWN_LEFT_MAX: 
			newFacing = DownLeft 
		elif facingAngle >= FACE_DOWN_MIN and facingAngle < FACE_DOWN_MAX: 
			newFacing = Down
		elif facingAngle >= FACE_DOWN_RIGHT_MIN and facingAngle < FACE_DOWN_RIGHT_MAX: 
			newFacing = DownRight
		elif facingAngle >= FACE_RIGHT_MIN and facingAngle < FACE_RIGHT_MAX: 
			newFacing = Right
		elif facingAngle >= FACE_UP_RIGHT_MIN and facingAngle < FACE_UP_RIGHT_MAX: 
			newFacing = UpRight
		elif facingAngle >= FACE_UP_MIN and facingAngle < FACE_UP_MAX: 
			newFacing = Up
		elif facingAngle >= FACE_UP_LEFT_MIN and facingAngle < FACE_UP_LEFT_MAX: 
			newFacing = UpLeft
		if newFacing != facing:
			var cardinalFacingAngle = round(facingAngle/HALF_SECTOR_DEG)*HALF_SECTOR_DEG
			emit_signal("facingChange", facing, newFacing, cardinalFacingAngle)
			facing = newFacing

func checkInputs(_delta):
	var nextAction = None
	if Input.is_action_pressed(upControl):
		nextAction = Up
	if Input.is_action_pressed(downControl):
		if nextAction == Up: nextAction = None
		else: nextAction = Down
	if Input.is_action_pressed(leftControl):
		if nextAction == Up: nextAction = UpLeft
		elif nextAction == Down: nextAction = DownLeft
		else: nextAction = Left
	elif Input.is_action_pressed(rightControl):
		if nextAction == Up: nextAction = UpRight
		elif nextAction == Down: nextAction = DownRight
		else: nextAction = Right
	if moveDirection != nextAction:
		changeMovementDirection(nextAction)
	updateMovement(_delta)
	

func changeMovementDirection(newDirection):
	moveDirection = newDirection

func updateMovePenalty(curDir, straightDir, foreDir1, foreDir2, sideDir1, sideDir2):
	animateBackward = false
	match curDir:
		straightDir: movingBackwardPenalty = MOVE_STRAIGHT_PENALTY
		foreDir1, foreDir2: movingBackwardPenalty = MOVE_FORWARD_PENALTY
		sideDir1, sideDir2: movingBackwardPenalty = MOVE_SIDE_PENALTY
		_: 
			animateBackward = true
			movingBackwardPenalty = MOVE_BACK_PENALTY

func updateMovement(_delta):
	#reverseMovement = false # Are we walking backward?
	var newAnimation = null
	var newMoveVector = null
	var newFlipped = flipped
	match moveDirection:
		Up: 
			newMoveVector = upVector
		UpLeft:
			newMoveVector = upLeftVector
		UpRight:
			newMoveVector = upRightVector
		Left:
			newMoveVector = leftVector
		Right:
			newMoveVector = rightVector
		Down: 
			newMoveVector = downVector
		DownLeft:
			newMoveVector = downLeftVector
		DownRight:
			newMoveVector = downRightVector
		None:
			newMoveVector = noneVector
			
	var oldAnimateBackward = animateBackward
	match facing:
		Up: 
			if isMoving(): newAnimation = "moveUp"
			else: newAnimation = "idleUp"
			newFlipped = false
			updateMovePenalty(newMoveVector, upVector, upLeftVector, upRightVector, leftVector, rightVector)
		UpLeft:
			if isMoving(): newAnimation = "moveUpRight"
			else: newAnimation = "idleUpRight"
			newFlipped = true
			updateMovePenalty(newMoveVector, upLeftVector, upVector, leftVector, downLeftVector, upRightVector)
		UpRight:
			if isMoving(): newAnimation = "moveUpRight"
			else: newAnimation = "idleUpRight"
			newFlipped = false
			updateMovePenalty(newMoveVector, upRightVector, upVector, rightVector, upLeftVector, downRightVector)
		Left:
			if isMoving(): newAnimation = "moveRight"
			else: newAnimation = "idleRight"
			newFlipped = true
			updateMovePenalty(newMoveVector, leftVector, upLeftVector, downLeftVector, upVector, downVector)
		Right:
			if isMoving(): newAnimation = "moveRight"
			else: newAnimation = "idleRight"
			newFlipped = false
			updateMovePenalty(newMoveVector, rightVector, upRightVector, downRightVector, upVector, downVector)
		Down: 
			if isMoving(): newAnimation = "moveDown"
			else: newAnimation = "idleDown"
			newFlipped = false
			updateMovePenalty(newMoveVector, downVector, downLeftVector, downRightVector, leftVector, rightVector)
		DownLeft:
			if isMoving(): newAnimation = "moveDownRight"
			else: newAnimation = "idleDownRight"
			newFlipped = true
			updateMovePenalty(newMoveVector, downLeftVector, downVector, leftVector, upLeftVector, downRightVector)
		DownRight:
			if isMoving(): newAnimation = "moveDownRight"
			else: newAnimation = "idleDownRight"
			newFlipped = false
			updateMovePenalty(newMoveVector, downRightVector, downVector, rightVector, upRightVector, downLeftVector)
		None:
			pass
		
	if newAnimation != animation or newFlipped != flipped or (!playingAnimation && isMoving()) or (oldAnimateBackward != animateBackward):
		animation = newAnimation
		flipped = newFlipped
		animatedSprite.stop()
		animatedSprite.play(animation, animateBackward)
		playingAnimation = true
		if !isMoving():
			animatedSprite.stop()
			animatedSprite.frame = 0
			playingAnimation = false
		animatedSprite.flip_h = flipped
		#print("Changing animation: ", animation, " flipped: ", flipped)
		
	if newMoveVector != moveVector:
		#print("Changing move vector: ", moveVector, " became ", newMoveVector)
		moveVector = newMoveVector
		if moveVector == Vector2.ZERO:
			animatedSprite.stop()
			animatedSprite.frame = 0
			playingAnimation = false
