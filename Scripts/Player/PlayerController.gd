extends Node
class_name PlayerController

@export var player_movement : PlayerMovement
var direction : Vector2 = Vector2(0, 0)

signal moving_signal(direction: Vector2)

	
func _input(_event: InputEvent) -> void:
	handle_inputs()

	
func handle_inputs() -> void:
	movement_input()
	pause_game()


func movement_input() -> void:
	direction = Vector2.ZERO

	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
		
	if direction.length() > 1:
		direction = direction.normalized()
		
	moving_signal.emit(direction)
	apply_direction()


func apply_direction() -> void:
	player_movement.initiate_move(direction)

	
func pause_game() -> void:
	if Input.is_action_just_pressed("pause"):
		SignalBus.pause_pressed.emit(true)
