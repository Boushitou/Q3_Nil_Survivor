class_name ItemDisplay

extends Button

@export var item_name : Label
@export var item_description : Label
@export var item_level : Label
@export var item_icon : TextureRect

var item_data : Items

signal item_selected_signal(item_data: Items)


func _ready():
	button_up.connect(_on_item_selected.bind())


func set_item_data(item: Dictionary, player_stats: PlayerStats, level : int, first_time: bool):
	if item["type"] == "passive":
		item_data = PassiveItem.new(item, player_stats)
	elif item["type"] == "weapon":
		item_data = Weapon.new(item, player_stats)
	else:
		item_data = Items.new(item, player_stats)
	
	item_name.text = item_data.item_name
	
	if first_time:
		item_level.text = "NEW !"
	else:
		item_level.text = "Level : " + str(level)
		
	item_description.text = item_data.get_effect_description(level - 1)
	item_icon.texture = item_data.icon


func _on_item_selected():
	emit_signal("item_selected_signal", item_data)
