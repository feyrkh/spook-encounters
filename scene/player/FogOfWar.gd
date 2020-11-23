extends Node2D

const FOG_OF_WAR_CHUNK = preload("res://scene/player/FogOfWarChunk.tscn")
export(int) var chunkWidth = 40
export(int) var chunkHeight = 40

func _ready():
	for x in range(-600, 600, chunkWidth):
		for y in range(-320, 320, chunkHeight):
			var chunk:ColorRect = FOG_OF_WAR_CHUNK.instance()
			add_child(chunk)
			chunk.rect_position = Vector2(x, y)
			chunk.rect_size = Vector2(chunkWidth, chunkHeight)
