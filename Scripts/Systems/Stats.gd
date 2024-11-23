class_name Stats

extends Node

@export var health : Health
@export var speed : float
@export var power : int

var level = 1

func get_damage() -> int:
	return power
