extends Node
class_name Stats

@export var health : Health
var speed : float
var power : int

var level : int = 1

func get_damage() -> int:
	return power
