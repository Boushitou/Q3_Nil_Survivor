extends "res://Data/Weapon.gd"

var javelin_scene = preload("res://Scenes/Weapons/javelin.tscn")

func create_attack(_player_stats: PlayerStats, level: int, inventory : Inventory,
position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO, _horizontal_direction : Vector2 = Vector2.ZERO) -> Node:
	var total_area_x = base_area.x * bonus_area[level - 1] * inventory.get_total_passive_items_bonuses("atk_range")
	
	direction.normalized()	

	var angle = direction.angle()	

	var offset_distance = total_area_x * 0.5
	var offset_x = offset_distance * cos(angle)
	var offset_y = offset_distance * sin(angle)
	var spawn_position = position + Vector2(offset_x, offset_y)

	var weapon = PoolSystem.instantiate_object(name, javelin_scene, spawn_position, angle, _player_stats)
	
	var javelin : Projectile = weapon
	javelin.initialize_projectile(projectile_speed[level - 1], direction, piercing_power[level - 1])
	
	return weapon	
