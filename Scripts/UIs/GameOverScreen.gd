extends Menu
class_name GameOverScreen

@export var game_over_label : Label
@export var retry_button : Button
@export var win_color : Color = Color(0.353, 0.784, 0.098)
@export var lose_color : Color = Color(0.784, 0.098, 0.098)

var game_over_text : String = "Game Over"

func _ready() -> void:
	SignalBus.connect("time_over", on_game_win)
	game_over_label.modulate = lose_color
	game_over_label.text = game_over_text
	
	
func on_game_win() -> void:
	game_over_label.text = "Your time is up"
	game_over_label.modulate = win_color


func _on_retry_button_button_up():
	change_scene("res://Scenes/main_game.tscn")


func _on_quit_button_button_up():
	quit_game()


func _on_draw():
	retry_button.grab_focus()
