extends Node
class_name GameManager

@export var player : Node
@export var game_over_menu : GameOverScreen
var game_is_paused : bool = false
var can_pause : bool = true

signal display_pause_menu(can_display : bool)

func _ready() -> void:
	var player_health = player.get_node("Health")
	if player_health != null:
		player_health.connect("has_died", on_game_over)
		
	SignalBus.connect("pause_pressed", pause_game)
	SignalBus.connect("enable_pause", enable_pause)

	
func on_game_over() -> void:
	game_over_menu.show()
	pause_game(false)

	
func pause_game(can_display_pause : bool) -> void:
	if can_pause:
		if game_is_paused:
			get_tree().paused = false
			game_is_paused = false
			
			if can_display_pause:
				display_pause_menu.emit(false)
			Engine.time_scale = 1.0	
		else:
			get_tree().paused = true
			game_is_paused = true 
 		
			if can_display_pause:
				display_pause_menu.emit(true)
			Engine.time_scale = 0.0
		
		#print("game is paused ? : ", game_is_paused)
		
func enable_pause(pause_enabled : bool) -> void:
	can_pause = pause_enabled
	#print("can pause ? : ", can_pause)
