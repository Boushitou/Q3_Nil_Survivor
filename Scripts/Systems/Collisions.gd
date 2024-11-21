class_name Collisions

extends Node

@export var health : Health
@export var group_name : String

var areas_in_range : Array = []
const i_frame = 0.5
var i_frame_timer = 0.0

func _process(delta):
	i_frame_timer += delta

	if i_frame_timer >= i_frame:
		apply_damage()
		i_frame_timer = 0.0


func _on_body_area_entered(area):
	if area.is_in_group(group_name):
		areas_in_range.append(area)
		

func _on_body_area_exited(area):
	if area.is_in_group(group_name):
		areas_in_range.erase(area)


func apply_damage():
	for area in areas_in_range:
		health.take_damage(1.0)
