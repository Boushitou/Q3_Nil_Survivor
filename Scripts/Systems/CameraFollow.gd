extends Camera2D
class_name CameraFollow

@export var smooth_factor : float
var target : Node2D
var old_target_pos : Vector2

@export_range(1, 10) var distance_scale : float


func _ready() -> void:
	target = $"../Player/Body"
	if target != null:
		old_target_pos = target.position


func _process(delta) -> void:
	if target != null:
		smooth_follow(delta)


func smooth_follow(delta) -> void:
	var distance : float = old_target_pos.distance_to(target.position)

	old_target_pos = target.position
	
	var dynamic_smooth_factor : float = smooth_factor + (distance * distance_scale)
	
	position = Utilities.exp_decay(position, target.position, dynamic_smooth_factor, delta)


func get_spawn_distance(camera_buffer : int) -> float:
	var screen_size : Vector2 = get_viewport_rect().size
	return screen_size.length() * 0.5 + camera_buffer


func get_spawn_position(spawn_distance : float) -> Vector2:
	if target == null:
		return Vector2.ZERO
		
	var angle : float = randf() * TAU
	var spawn_offset : Vector2 = Vector2(cos(angle), sin(angle)) * spawn_distance
	var spawn_position : Vector2 = target.global_position + spawn_offset

	return spawn_position
