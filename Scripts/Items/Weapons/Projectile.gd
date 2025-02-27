extends "res://Scripts/Items/Weapons/WeaponBehavior.gd"
class_name Projectile

var projectile_speed : float = 0
var projectile_direction : Vector2 = Vector2.ZERO

var pierce_power : int = 0
var hit_count : int = 0


func _process(delta: float) -> void:
	move_projectile(delta)

	
func initialize_projectile(speed : float , direction : Vector2, piercing : int) -> void:
	projectile_speed = speed
	projectile_direction = direction
	pierce_power = piercing
	

func move_projectile(delta : float) -> void:
	var velocity = projectile_direction * projectile_speed
	var move = velocity * delta
	global_position += move
