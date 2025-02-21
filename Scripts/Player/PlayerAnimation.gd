extends AnimatedSprite2D
class_name PlayerAnimation

@export var player_controller : PlayerController
@export var health : Health
@export var animation_player : AnimationPlayer
@export var blood_splash : PackedScene

func _ready() -> void:
	player_controller.connect("moving_signal", set_moving_animation)
	health.connect("take_damage_signal", damage_particles_effect)

	
func set_moving_animation(direction : Vector2) -> void:
	if get_tree().paused:
		return
	
	if direction == Vector2.ZERO:
		play("idle")
	else:
		play("walk")
		
		if direction.x != 0:
			flip_h = direction.x < 0

			
func damage_particles_effect(_amount) -> void :
	if animation_player != null:
		if not animation_player.is_playing():
				animation_player.play("damaged_animation")
	
		
	var random_offset = Utilities.get_random_float(0.0, sprite_frames.get_frame_texture(animation, frame).get_size().y / 2)
	var pos_offset = global_position + Vector2.UP * random_offset
	
	var particles_name = "blood_splash"
	var particles = PoolSystem.instantiate_object(particles_name, blood_splash, pos_offset, 0.0, get_tree().root)
	particles.particles_type = particles_name
