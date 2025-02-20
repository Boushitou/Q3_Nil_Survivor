extends AnimatedSprite2D
class_name PlayerAnimation

@export var player_controller : PlayerController

func _ready() -> void:
	player_controller.connect("moving_signal", set_moving_animation)

	
func set_moving_animation(direction : Vector2) -> void:
	if get_tree().paused:
		return
	
	if direction == Vector2.ZERO:
		play("idle")
	else:
		play("walk")
		
		if direction.x != 0:
			flip_h = direction.x < 0
