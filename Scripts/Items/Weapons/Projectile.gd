extends "res://Scripts/Items/Weapons/WeaponBehavior.gd"
class_name Projectile

var projectile_speed : float = 0
var projectile_direction : Vector2 = Vector2.ZERO

var pierce_power : int = 0
var current_hit_count : int = 0


func _ready() -> void:
	var notifier = VisibleOnScreenNotifier2D.new()
	add_child(notifier)
	notifier.connect("screen_exited", remove_projectile)


func _process(delta: float) -> void:
	move_projectile(delta)

	
func initialize_projectile(speed : float , direction : Vector2, piercing : int) -> void:
	current_hit_count = 0
	projectile_speed = speed
	projectile_direction = direction
	pierce_power = piercing
	

func move_projectile(delta : float) -> void:
	var velocity = projectile_direction.normalized() * projectile_speed
	var move = velocity * delta
	global_position += move


func _on_area_2d_on_enemy_hit():
	current_hit_count += 1

	if current_hit_count >= pierce_power:
		remove_projectile()

		
func remove_projectile() -> void:
	PoolSystem.pool_object(weapon.item.name, self)
