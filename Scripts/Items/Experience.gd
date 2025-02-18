extends Area2D
class_name Experience

@export var smooth_factor : float
@export_range(0.1, 10) var distance_scale : float

var xp_orb_manager : XpOrbManager
var value : int = 2
var min_speed : float = 400

var is_absorbed : bool = false
var target : Node2D
var old_target_pos : Vector2

@export var bounce_duration : float = 0.1
var bounce_time : float = 0.0

var xp_particles : PackedScene = preload("res://Scenes/xp_particles.tscn")

func _ready() -> void:
	xp_orb_manager = get_parent()


func _process(delta: float) -> void:
	if not is_absorbed:
		return
		
	move_toward_player(delta)
		
	
func _on_hidden() -> void:
	xp_orb_manager.remove_orb(self)
	is_absorbed = false

	
func start_moving(target_pos : Node2D) -> void:
	if is_absorbed:
		return
		
	var particles_name = "xp_particles"
	var particles = PoolSystem.instantiate_object(particles_name, xp_particles, global_position, 0.0, get_tree().root)
	particles.particles_type = particles_name
	
	old_target_pos = target_pos.global_position
	is_absorbed = true
	target = target_pos
	bounce_time = 0.0
	
	
func move_toward_player(delta : float) -> void:
	if target == null:
		return

	var distance : float = old_target_pos.distance_to(target.global_position)

	old_target_pos = target.global_position

	var dynamic_smooth_factor : float = smooth_factor + (distance * distance_scale)
	var new_position : Vector2 = Utilities.exp_decay(position, target.global_position, dynamic_smooth_factor, delta)
	var move_vector : Vector2 = new_position - position
	
	if bounce_time < bounce_duration:
		var t : float = bounce_time / bounce_duration
		var bounce_effect : float = Utilities.ease_in_back(t)
		move_vector *= bounce_effect
		bounce_time += delta
	
	if move_vector.length() < min_speed * delta:
		move_vector = move_vector.normalized() * min_speed * delta
		
	position += move_vector	
