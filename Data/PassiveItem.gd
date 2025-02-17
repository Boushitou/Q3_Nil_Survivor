class_name PassiveItem

extends "res://Data/Item.gd"


@export var stats_upgraded : Array[Dictionary] #[stat_name : String, factor : float]
@export var is_multiplicative : bool = true
@export var apply_instant : bool = false #if the item has an instant effect of if the value will be used in later calculation

#basic passive item are multiplicative
func apply_effect(player_stats: PlayerStats, level: int):
	if not apply_instant:
		return
		
	if level >= stats_upgraded.size():
		return;

	var effects = stats_upgraded[level]

	for stat_name in effects.keys():
		var factor = effects[stat_name]

		var increased_value = 0	
		var stat_value = player_stats.get_stat_value(stat_name)

		if is_multiplicative:
			increased_value = (stat_value * (factor - 1)) + stat_value
		else:
			increased_value = stat_value + factor

		player_stats.increase_stat(stat_name, increased_value)
		print("increased value for ", stat_name, " : ",  increased_value)
