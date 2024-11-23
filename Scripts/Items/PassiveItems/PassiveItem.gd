class_name PassiveItem

var level = 1
var passive_name = ""
var effects = []
var player_stats : PlayerStats

func _init(passive: Dictionary, stats: PlayerStats):
	set_passive_effects(passive)
	player_stats = stats


func level_up():
	if level + 1 > 5:
		print("This passive can't level up anymore !")
		return
		
	level += 1
	apply_effects()
	print("passive leveled up : ", passive_name, " level : ", level)


func apply_effects():
	for effect_list in effects:
		var effect = effect_list[level - 1]
		var stat_name = effect["stat"]
		var factor = effect["factor"]
		var stat_value = player_stats.get_stat_value(stat_name)
		
		var increased_value = stat_value * (factor - 1)
		player_stats.increase_stat(stat_name, increased_value)
		
		print("increased value for ", stat_name, " : ", stat_value + increased_value)
		
		
func set_passive_effects(passive: Dictionary):
	effects = passive["effects"]
	passive_name = passive["name"]
	
	
func get_effect_description(index: int) -> String:
	var description = ""
	description = effects[index]["description"]
	print("item description :", description)
	return description
