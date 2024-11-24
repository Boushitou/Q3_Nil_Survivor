class_name Inventory

extends Node

@export var player_stats : PlayerStats

var passives_items = []
var weapons = []

var max_passives = 3
var max_weapons = 2
	

func add_item(item: Items):
	if item is PassiveItem:
		passives_items.append(item)
	else:
		weapons.append(item)

	item.apply_effects()
	print("passive item added : ", item.item_name)
	


func level_up_item(item: Items):
	var items = passives_items + weapons
	var correct_item = null
	
	for i in items:
		if i.item_name == item.item_name:
			correct_item = i
			break
			
	if correct_item == null:
		print(" item not found")
		return
		
	correct_item.level_up()


func get_item_by_name(item_name : String) -> Items:
	var items = passives_items + weapons
	
	for i in items:
		if i.item_name == item_name:
			return i
	
	return null


func weapons_slots_full() -> bool:
	return weapons.size() >= max_weapons


func passives_slots_full() -> bool:
	return passives_items.size() >= max_passives


func item_is_level_max(item : Items) -> bool:
	return item.level >= item.max_level

func get_player_stats():
	return player_stats
