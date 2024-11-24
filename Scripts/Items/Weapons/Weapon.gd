class_name Weapon

extends "res://Scripts/Items/Items.gd"


func _init(item_type: Dictionary, stats: PlayerStats):
	max_level = 8
	super(item_type, stats)