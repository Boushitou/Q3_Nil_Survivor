extends "res://Data/Weapon.gd"

var javelin_scene = preload("res://Scenes/Weapons/javelin.tscn")

func create_attack(_player_stats: PlayerStats, level: int, inventory : Inventory,
position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO, _horizontal_direction : Vector2 = Vector2.ZERO) -> Array:
	
	var weapons = []
	var total_area_x = base_area.x * bonus_area[level - 1] * inventory.get_total_passive_items_bonuses("atk_range")
	
	direction = direction.normalized()	

	var angle = direction.angle()	
	var num_javelins = clamp(amount[level - 1], 1, max_amount)
	var spread_angle = deg_to_rad(10)
	
	var middle_index = (num_javelins - 1) * 0.5
	
	for i in range(num_javelins):
		var angle_offset = (i - middle_index) * spread_angle
		var javelin_direction = direction.rotated(angle_offset)
		
		var offset_distance = total_area_x * 0.5
		var offset_x = offset_distance * cos(angle + angle_offset)
		var offset_y = offset_distance * sin(angle + angle_offset)
		var spawn_position = position + Vector2(offset_x, offset_y)
		
		var weapon = PoolSystem.instantiate_object(name, javelin_scene, spawn_position, javelin_direction.angle(), _player_stats)
		var javelin : Projectile = weapon
		javelin.initialize_projectile(projectile_speed[level - 1], javelin_direction, piercing_power[level - 1])
		weapons.append(javelin)
	
	return weapons
