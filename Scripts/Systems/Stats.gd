class_name Stats

extends Node

@export var health : Health
@export var speed : float
@export var power : int

var level = 1

func increase_hp(value : int):
	health.upgrade_health(value)


func get_damage() -> int:
	return power
