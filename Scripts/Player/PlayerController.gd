extends Node
class_name PlayerController

@export var player_movement : PlayerMovement
var direction = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	handle_inputs()


func handle_inputs():
	movement_input()


func movement_input():
#	if Input.is_action_pressed("move_left"):
#		direction.x = -1
#	elif Input.is_action_pressed("move_right"):
#		direction.x = 1
#	else:
#		direction.x = 0
#		
#	if Input.is_action_pressed("move_up"):
#		direction.y = -1
#	elif Input.is_action_pressed("move_down"):
#		direction.y = 1
#	else:
#		direction.y = 0
	
	direction = Vector2.ZERO

	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
		
	if direction != Vector2():
		direction = direction.normalized()
		
	apply_direction()


func apply_direction():
	player_movement.initiate_move(direction)
