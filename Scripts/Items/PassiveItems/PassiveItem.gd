class_name PassiveItem

extends "res://Scripts/Items/Items.gd"


func _init(item_type: Dictionary, stats: PlayerStats):
	max_level = 5
	super(item_type, stats)


func apply_effects():
	for effect_list in effects:
		var effect = effect_list[level - 1]
		var stat_item_name = effect["stat"]
		var factor = effect["factor"]
		var stat_value = player_stats.get_stat_value(stat_item_name)
		
		var increased_value = 0
		
		if is_multiplicative:
			increased_value = stat_value * (factor - 1)
			increased_value += stat_value
		else:
			increased_value = stat_value + factor
				
		player_stats.increase_stat(stat_item_name, increased_value)
		
		print("increased value for ", stat_item_name, " : ",  increased_value)
