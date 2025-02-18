extends Area2D
class_name XPCollision

func _on_area_entered(area) -> void:
	if area is Experience:
		area.start_moving(self)
