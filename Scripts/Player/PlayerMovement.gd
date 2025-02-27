extends Node2D
class_name PlayerMovement

enum Movement_State {IDLE, MOVING}

@export var player_stats : PlayerStats
@export var inventory : Inventory

var movement : Vector2 = Vector2(0, 0)
var state : Movement_State = Movement_State.IDLE
var current_attack_direction : Vector2 = Vector2(1, 0)  #game starts facing right for weapon and sprite
var last_horizontal_direction : Vector2 = Vector2(1, 0)

func _ready() -> void:
	add_to_group("player")


func _process(delta) -> void:
	move(delta)
	

func initiate_move(direction : Vector2) -> void:
	movement = player_stats.get_stat_value("speed") * direction
		
	if movement == Vector2():
		state = Movement_State.IDLE
	else:
		if direction.x != 0:
			last_horizontal_direction = Vector2(sign(direction.x), 0)
		current_attack_direction = direction
			
		state = Movement_State.MOVING
		

func move(delta : float) -> void:
	if state == Movement_State.MOVING:
		position += movement * delta
