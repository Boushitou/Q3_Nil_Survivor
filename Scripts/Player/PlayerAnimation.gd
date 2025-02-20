extends AnimatedSprite2D
class_name PlayerAnimation

@export var player_controller : PlayerController

var animation_paused : bool = false

func _ready() -> void:
	player_controller.connect("moving_signal", set_moving_animation)
	SignalBus.connect("pause_pressed", on_animation_paused)
	
	
func set_moving_animation(direction : Vector2) -> void:
	if not animation_paused:
		if direction == Vector2.ZERO:
			play("idle")
		else:
			play("walk")
			
			if direction.x != 0:
				flip_h = direction.x < 0

		
func on_animation_paused() -> void:
	animation_paused = not animation_paused
