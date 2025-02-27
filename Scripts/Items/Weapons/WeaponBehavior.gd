extends Node2D
class_name WeaponBehavior

@export var sprite : AnimatedSprite2D
@export var collider : CollisionModifier
@export var weapon_area : WeaponsCollision
@export var weapon_timer : WeaponTimer

var weapon : Items

func initialize_weapon(weapon_data : Items, inventory: Inventory, player_stats : PlayerStats) -> void:
	if not weapon_area or not weapon_data.item is Weapon:
		return
		
	weapon = weapon_data
	weapon_area.set_weapon(weapon_data, player_stats)
	
	var size : Vector2 = weapon.item.base_area * weapon.item.bonus_area[weapon_data.level - 1] * inventory.get_total_passive_items_bonuses("atk_range")
	collider.update_collider(size, sprite)
	
	if weapon.item.duration[weapon_data.level - 1] > 0:
		weapon_timer.set_duration(weapon.item.duration[weapon_data.level - 1])

	
func _on_timer_timeout() -> void:
	PoolSystem.pool_object(weapon.item.name, self)


func _on_draw():
	weapon_area.set_monitoring(true)


func _on_hidden():
	weapon_area.set_monitoring(false)
