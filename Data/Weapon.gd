class_name Weapon

extends "res://Data/Item.gd"

@export var damage : Array[int]
@export var push_back_force : float
@export var atk_speed : Array[float]
@export var base_area :Vector2
@export var bonus_area : Array[float]
@export var projectile_speed : Array[float]
@export var hit_delay : Array[float]
@export var duration: Array[float] #weapon don't have a duration system if set to -1

func get_damage(level : int):
	return damage[level]


func get_push_back_force() -> float:
	return push_back_force


func create_attack(_player_stats: PlayerStats, _level: int, _inventory : Inventory,
_position : Vector2 = Vector2.ZERO, _direction : Vector2 = Vector2.ZERO) -> Node:
	return null
