class_name Weapon

extends "res://Data/Item.gd"

@export var damage : Array[int]
@export var atk_speed : Array[float]
@export var area : Array[Vector2]
@export var projectile_speed : Array[float]
@export var hit_delay : Array[float]
@export var duration: Array[float] #weapon don't have a duration system if set to -1

func get_damage(level : int):
	return damage[level]


func create_attack(_player_stats: PlayerStats, _level: int, 
_position : Vector2 = Vector2.ZERO, _direction : Vector2 = Vector2.ZERO) -> Node:
	return null
