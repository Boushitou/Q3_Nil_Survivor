extends Node
class_name PlayerController

@export var player_movement : PlayerMovement
var direction : Vector2 = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	handle_inputs()


func handle_inputs() -> void:
	movement_input()


func movement_input() -> void:
	direction = Vector2.ZERO

	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
		
	if direction.length() > 1:
		direction = direction.normalized()
		
	apply_direction()


func apply_direction() -> void:
	player_movement.initiate_move(direction)
