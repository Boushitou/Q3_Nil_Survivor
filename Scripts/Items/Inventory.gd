class_name Inventory

extends Node

@export var player_stats : PlayerStats

var passives_items = []
var weapons = []

var max_passives = 3
var max_weapons = 3

var passives_data = {}


func _ready():
	var passives_file = FileAccess.open("res://Data/Items/PassiveItems.json", FileAccess.READ)
	
	if passives_file:
		passives_data = JSON.parse_string(passives_file.get_as_text())
		passives_file.close()

	

func add_passive_item(passive: PassiveItem):
	passives_items.append(passive)
	passive.apply_effects()
	print("passive item added : ", passive.passive_name)
	


func level_up_passive_item(passive: PassiveItem):
	var item = null
	for passive_item in passives_items:
		if passive.passive_name == passive_item.passive_name:
			item = passive_item
			break
			
	if item == null:
		print("passive item not found")
		return
		
	item.level_up()


func get_player_stats():
	return player_stats
