extends AnimatedSprite


onready var source = $'../AnimatedSprite'

func _ready():
	visible = true

func _on_AnimatedSprite_frame_changed():
	print('changing to ', source.animation, ' frame ', source.frame)
	self.animation = source.animation
	self.frame = source.frame
	self.flip_h = source.flip_h

func _on_MoveController_facingChange(facing, newFacing, cardinalFacingAngle):
	_on_AnimatedSprite_frame_changed()

func _on_MoveController_updatedAnimation():
	_on_AnimatedSprite_frame_changed()
