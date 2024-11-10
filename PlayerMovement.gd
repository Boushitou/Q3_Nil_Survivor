extends Node2D


@export var speed = 20.0
const DASH_FORCE = 400
var movement = Vector2(0, 0)

func _process(delta):
	position += movement * delta

func move(direction):
	movement = direction * speed
