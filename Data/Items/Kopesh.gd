extends "res://Data/Weapon.gd"
class_name Kopesh

var kopesh_scene = preload("res://Scenes/Weapons/kopesh.tscn")
		
func create_attack(_player_stats: PlayerStats, _level: int, position : Vector2 = Vector2.ZERO) -> Node:
	var weapon = PoolSystem.instantiate_object(name, kopesh_scene, position, 0.0, _player_stats)
	return weapon
