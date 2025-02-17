extends Node
class_name PlayerAttack

@export var inventory : Inventory
@export var player_movement : PlayerMovement
@export var player_stats : PlayerStats

var weapons_cooldown : Dictionary = {}

func _ready() -> void:
	SignalBus.connect("get_new_weapon", add_weapon_cooldown)
	
	
func _process(delta: float) -> void:
	for w : Items in inventory.weapons:
		if w.item is Weapon:
			if weapons_cooldown.has(w.ID):
				weapons_cooldown[w.ID] -= delta
				attack(w)
	

func add_weapon_cooldown(weapon: Items) -> void:
	weapons_cooldown[weapon.ID] = weapon.item.atk_speed[weapon.level - 1]

	
func attack(w : Items) -> void:
	if not w.item is Weapon: 
		return 
	if weapons_cooldown[w.ID] <= 0.0: 
		var player : Node2D = get_parent()
		w.attack(player.global_position, player_movement.current_attack_direction, inventory)
		var player_cooldown : float = player_stats.get_stat_value("attack_speed")
		weapons_cooldown[w.ID] = w.item.atk_speed[w.level - 1] / player_cooldown
