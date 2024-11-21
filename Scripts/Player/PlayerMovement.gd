class_name PlayerMovement

extends Node2D

enum Movement_State {IDLE, MOVING, DASHING}

var player_stats

#region dash values
@export var DASH_FORCE : float
var dash_duration = 0.05
var dash_cooldown = 3.0
var dash_timer = 0.0
var cooldown_timer = 0.0
var dash_direction = Vector2(0, 0)
#endregion

var movement = Vector2(0, 0)
var state : Movement_State = Movement_State.IDLE


func _ready():
	player_stats = $PlayerStats
	add_to_group("player")


func _process(delta):
	move(delta)
	dashing(delta)


func initiate_move(direction):
	if direction != Vector2():
		dash_direction = direction
	
	if state != Movement_State.DASHING:
		movement = player_stats.get_stat_value("speed") * direction
		
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
		position += delta * movement
		
		dash_timer -= delta
		
		if dash_timer <= 0:
			state = Movement_State.IDLE
			cooldown_timer = dash_cooldown
			
	if dash_cooldown > 0:
		cooldown_timer -= delta
