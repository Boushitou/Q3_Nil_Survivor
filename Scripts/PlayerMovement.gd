extends Node2D

enum Movement_State {IDLE, MOVING, DASHING}

@export var speed : float

const DASH_FORCE = 3000
var dash_duration = 0.2
var dash_cooldown = 3.0
var dash_timer = 0.0
var cooldown_timer = 0.0
var dash_direction = Vector2(0, 0)

var movement = Vector2(0, 0)
var state : Movement_State = Movement_State.IDLE


func _process(delta):
	move(delta)
	dashing(delta)
	#print(state)


func initiate_move(direction):
	if direction != Vector2():
		dash_direction = direction
	
	if state != Movement_State.DASHING:
		movement = direction * speed
		
		if movement == Vector2():
			state = Movement_State.IDLE
		else:
			state = Movement_State.MOVING
			


func move(delta):
	if state == Movement_State.MOVING:
		position += movement * delta

func initiate_dash(direction):
	if cooldown_timer <= 0 && state != Movement_State.DASHING:
		state = Movement_State.DASHING
		dash_timer = dash_duration
		movement = dash_direction * DASH_FORCE


func dashing(delta):
	if state == Movement_State.DASHING:
		position += movement * delta
		
		dash_timer -= delta
		
		if dash_timer <= 0:
			state = Movement_State.IDLE
			cooldown_timer = dash_cooldown
			
	if dash_cooldown > 0:
		cooldown_timer -= delta
