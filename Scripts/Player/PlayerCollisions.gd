extends Node
class_name PlayerCollisions

@export var health : Health

var areas_in_range : Array[Area2D] = []
const i_frame : float = 0.5
var i_frame_timer : float = 0.0


func _process(delta) -> void:
	i_frame_timer += delta

	if i_frame_timer >= i_frame:
		apply_damage()
		i_frame_timer = 0.0


func _on_body_area_entered(area) -> void:
	if area.is_in_group("enemies"):
		areas_in_range.append(area)
	elif area is Experience:
		SignalBus.gain_xp.emit(area.value)
		PoolSystem.pool_object("xp_orb", area)

		
func _on_body_area_exited(area) -> void:
	if area.is_in_group("enemies"):
		areas_in_range.erase(area)


func apply_damage() -> void:
	for area : Area2D in areas_in_range:
		if not is_instance_valid(area) or not area.is_visible():
			areas_in_range.erase(area)
			continue
		var damage : int = area.get_damage()
		health.take_damage(damage)
