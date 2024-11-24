class_name ItemDisplay

extends Node

@export var item_name : Label
@export var item_description : Label
@export var item_level : Label
@export var item_icon : TextureRect

var item_data : Items

func set_item_data(item: Dictionary, player_stats: PlayerStats):
	item_data = Items.new(item, player_stats)
	
	item_name.text = item_data.item_name
	item_level.text = "Level : " + str(item_data.level)
	item_description.text = item_data.get_effect_description(item_data.level - 1)
	item_icon.texture = item_data.icon
