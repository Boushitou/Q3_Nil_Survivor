class_name PlayerController

extends Node

@export var player_movement : PlayerMovement
var direction = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	handle_inputs()


func handle_inputs():
	movement_input()
	dash_input()


func movement_input():
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	elif Input.is_action_pressed("move_right"):
		direction.x = 1
	else:
		direction.x = 0
		
	if Input.is_action_pressed("move_up"):
		direction.y = -1
	elif Input.is_action_pressed("move_down"):
		direction.y = 1
	else:
		direction.y = 0
		
	if direction != Vector2():
		direction = direction.normalized()
		
	apply_direction()


func apply_direction():
	player_movement.initiate_move(direction)


func dash_input():
	if Input.is_action_just_pressed("dash"):
		player_movement.initiate_dash(direction)
