extends TextureProgressBar
class_name HealthBar

@export var health : Health


func _ready() -> void:
	health.connect("change_health_signal", update_texture_value)
	health.connect("health_upgrade_signal", update_texture_max_value)
	max_value = health.total_health
	value = max_value
	
	
func update_texture_value(current_health : int):
	value = current_health

	
func update_texture_max_value(total_health : int):
	max_value = total_health
