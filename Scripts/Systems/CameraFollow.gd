class_name CameraFollow

extends Camera2D

@export var smooth_factor : float
var target : Node2D
var old_target_pos : Vector2

@export_range(1, 10) var distance_scale : float


func _ready():
	target = $"../Controller/Player"
	if target != null:
		old_target_pos = target.position


func _process(delta):
	smooth_follow(delta)


func smooth_follow(delta):
	var distance = old_target_pos.distance_to(target.position)

	old_target_pos = target.position
	
	var dynamic_smooth_factor = smooth_factor + (distance * distance_scale)
	
	position = Utilities.exp_decay(position, target.position, dynamic_smooth_factor, delta)