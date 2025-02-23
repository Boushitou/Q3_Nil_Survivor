extends VBoxContainer
class_name StatsDisplayer

@export var stat_labels : Dictionary
@export var label_settings : LabelSettings

var player_stats : PlayerStats
var game_manager : GameManager


# Mapping stat keys to display names
const STAT_NAME_MAPPING := {
	"health": "Health",
	"health_regeneration": "Health Regeneration",
	"power": "Damage",
	"attack_speed": "Attack Speed",
	"atk_range": "Attack Range",
	"speed": "Movement Speed"
	}

func _ready() -> void:
	player_stats = get_node("/root/MainGame/Player/PlayerStats")
	game_manager = get_node("/root/MainGame")
	
	game_manager.connect("display_pause_menu", update_stats_display)
	
	for key in stat_labels.keys():
		var label = Label.new()
		var display_name = STAT_NAME_MAPPING.get(key, key.capitalize()) # Fallback to capitalized key if not in dictionary
		label.text = "%s: 0" % display_name
		stat_labels[key] = label
		add_child(label)
		label.label_settings = label_settings
		

func update_stats_display(_can_display) -> void:
	if not player_stats:
		return

	for stat_name in stat_labels.keys():
		if player_stats.stats.has(stat_name):
			var display_name = STAT_NAME_MAPPING.get(stat_name, stat_name.capitalize())
			var label : Label = stat_labels[stat_name]
			label.text = "%s: %s" % [display_name, player_stats.stats[stat_name]]
