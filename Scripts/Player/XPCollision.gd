class_name XPCollision

extends Area2D

func _on_area_entered(area):
	if area is Experience:
			area.start_moving(self)
