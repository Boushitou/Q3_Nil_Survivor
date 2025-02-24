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
const PERCENTAGE_STATS := ["power", "attack_speed", "atk_range"]

func _ready() -> void:
	player_stats = get_node("/root/MainGame/Player/PlayerStats")
	game_manager = get_node("/root/MainGame")
	
	game_manager.connect("display_pause_menu", update_stats_display)
	
	setup_labels()

	
func setup_labels() -> void:
	for key in stat_labels.keys():
		var label = Label.new()
		var display_name = STAT_NAME_MAPPING.get(key, key.capitalize())
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
			var stat_value = player_stats.get_stat_value(stat_name)

			# If stat should be displayed as a percentage
			if stat_name in PERCENTAGE_STATS:
				stat_value = (stat_value - 1) * 100  # Convert 1.1 to 10%
				label.text = "%s: +%.1f%%" % [display_name, stat_value]
			else:
				label.text = "%s: %d" % [display_name, stat_value]
