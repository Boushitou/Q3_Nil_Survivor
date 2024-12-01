extends Area2D
class_name WeaponsCollision

var collider

var weapon : Weapon

func initialize_weapon(weapon_data : Weapon):
	if collider.shape is RectangleShape2D:
		pass
