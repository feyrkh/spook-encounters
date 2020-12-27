extends Node
class_name MoveStyle

signal move_complete()

var body:KinematicBody2D
var moveTarget:Position2D
var moveComplete = true

func setBody(_body:KinematicBody2D):
	body = _body

func startMove(_moveTarget:Position2D):
	moveTarget = _moveTarget
	moveComplete = false
