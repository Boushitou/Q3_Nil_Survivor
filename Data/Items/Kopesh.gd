extends "res://Data/Weapon.gd"

var kopesh_scene = preload("res://Scenes/Weapons/kopesh.tscn")
		
func create_attack(_player_stats: PlayerStats, level: int, inventory : Inventory,
position : Vector2 = Vector2.ZERO, _direction : Vector2 = Vector2.ZERO, horizontal_direction : Vector2 = Vector2.ZERO) -> Array:
	
	var weapons = []
	var total_area_x = base_area.x * bonus_area[level - 1] * inventory.get_total_passive_items_bonuses("atk_range")
		
	var offset = position.x + (total_area_x * 0.5) * horizontal_direction .x
	var spawn_position = Vector2(offset, position.y)
	var weapon = PoolSystem.instantiate_object(name, kopesh_scene, spawn_position, 0.0, _player_stats)
	weapon.get_node("WeaponBody/AnimatedSprite2D").flip_h = horizontal_direction.x < 0
	weapons.append(weapon)
	
	return weapons
