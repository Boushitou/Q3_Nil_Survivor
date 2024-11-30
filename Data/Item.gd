class_name Item

extends Resource

@export var ID : int
@export var name : String
@export var descriptions : Array[String]
@export var max_level : int = 8
@export var sprite : Texture2D

func apply_effect(player_stats: PlayerStats, level: int):
	print("A simple Item has no effects !")
