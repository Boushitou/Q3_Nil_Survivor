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
	var particles_name = "blood_splash"
	var particles = PoolSystem.instantiate_object(particles_name, blood_splash, get_parent().global_position, 0.0, self)
	particles.particles_type = particles_name
	print("damage_particles_effect")
