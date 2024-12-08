extends "res://Data/Weapon.gd"

var kopesh_scene = preload("res://Scenes/Weapons/kopesh.tscn")
		
func create_attack(_player_stats: PlayerStats, level: int,
position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO) -> Node:
	var offset = position.x + (area[level - 1].x * 0.5) * direction .x
	var spawn_position = Vector2(offset, position.y)
	var weapon = PoolSystem.instantiate_object(name, kopesh_scene, spawn_position, 0.0, _player_stats)
	return weapon
