class_name Experience

extends Area2D

var xp_orb_manager : XpOrbManager
var value : int = 2

func _ready() -> void:
	xp_orb_manager = get_parent()

func _on_hidden():
	xp_orb_manager.remove_orb(self)
