extends Area2D
class_name WeaponsCollision

@export var collider : CollisionModifier
var damage = 0

var enemies_in_range : Array[Enemy]
var hit_delay : float
var hit_timer = 0.0

func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)

func _physics_process(delta: float) -> void:
	if enemies_in_range.size() > 0:
		hit_timer += delta

		if hit_timer >= hit_delay:
			apply_damage()
			hit_timer = 0
	else:
		hit_timer = hit_delay


func set_weapon(weapon_data : Items, player_stats : PlayerStats):
	damage = weapon_data.item.get_damage(weapon_data.level - 1) * player_stats.get_stat_value("power")
	

func _on_area_entered(area):
	print("touching enemy")
	if area.is_in_group("enemies"):
		enemies_in_range.append(area)

		
func _on_area_exited(area):
	if area.is_in_group("enemies"):
		enemies_in_range.erase(area)
		
		
func apply_damage():
	for enemy in enemies_in_range:
		enemy.take_damage(damage)
		if not enemy.is_visible():
			enemies_in_range.erase(enemy)
