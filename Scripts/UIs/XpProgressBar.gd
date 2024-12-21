extends "res://Scripts/UIs/SmoothProgressBar.gd"
class_name XpProgressBar

@export var level_label : Label

func _ready() -> void:
	self.value = 0
	self.max_value = 5
	level_label.set_text("Lv. " + str(1))
	
	SignalBus.connect("gain_xp", on_gain_xp)
	SignalBus.connect("level_up_signal", on_level_up)


func on_gain_xp(amount : int) -> void:
	target_value += amount
	
	
func on_level_up(level : int, next_xp : int, current_xp : int) -> void:
	current_value = self.value
	target_value = current_xp
	self.max_value = next_xp
	level_label.set_text("Lv. " + str(level))
