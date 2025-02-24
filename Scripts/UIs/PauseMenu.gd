extends Menu
class_name PauseMenu

@export var game_manager : GameManager
@export var resume_button : Button

func _ready() -> void:
	if is_instance_valid(game_manager):
		game_manager.connect("display_pause_menu", display_pause_menu)
		
	visible = false
		
		
func display_pause_menu(can_display : bool) -> void:
	if can_display:
		visible = true
		resume_button.grab_focus()
	else:
		visible = false


func _on_resume_button_pressed():
	SignalBus.pause_pressed.emit(true)


func _on_fps_check_toggled(toggled_on):
	SignalBus.display_fps.emit(toggled_on)
