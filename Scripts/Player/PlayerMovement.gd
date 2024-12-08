extends Node2D
class_name PlayerMovement

enum Movement_State {IDLE, MOVING}

@export var player_stats : PlayerStats

var movement = Vector2(0, 0)
var state : Movement_State = Movement_State.IDLE
var current_attack_direction : Vector2 = Vector2(1, 0)  #game starts facing right for weapon and sprite

func _ready():
	add_to_group("player")


func _process(delta):
	move(delta)
	

func initiate_move(direction):
	movement = player_stats.get_stat_value("speed") * direction
		
	if movement == Vector2():
		state = Movement_State.IDLE
	else:
		if direction.x != 0:
			current_attack_direction.x = direction.x
		if direction.y != 0:
			current_attack_direction.y = direction.y
			
		state = Movement_State.MOVING
			


func move(delta):
	if state == Movement_State.MOVING:
		position += movement * delta