class_name Item

extends Resource

@export var ID : int
@export var name : String
@export_multiline var descriptions : Array[String]
@export var max_level : int = 8
@export var sprite : Texture2D

func apply_effect(_player_stats: PlayerStats, _level: int):
	print("A simple Item has no effects !")
	
	
