extends Node
class_name PlayerAttack

@export var inventory : Inventory
@export var player_stats : PlayerStats

var weapons : Array[Items]
var weapons_cooldown : Dictionary = {}

func _ready() -> void:
	SignalBus.connect("get_new_weapon", add_weapon)
	inventory.add_start_weapon()
	
	
func _process(delta: float) -> void:
	for w in weapons:
		if w.item is Weapon:
			if weapons_cooldown.has(w.ID):
				weapons_cooldown[w.ID] -= delta
				attack()
	

func add_weapon(weapon: Items) -> void:
	weapons.append(weapon)
	weapons_cooldown[weapon.ID] = weapon.item.atk_speed[weapon.level - 1]

	
func attack() -> void:
	for w in weapons:
		if not w.item is Weapon:
			continue
		if weapons_cooldown[w.ID] <= 0.0:
			print("attacking !")
			var player : Node2D = get_parent()
			w.attack(player.global_position)
			weapons_cooldown[w.ID] = w.item.atk_speed[w.level - 1]
			
			
		
func set_weapons_cooldown() -> void:
	for w in weapons:
		if w.item is Weapon:
			weapons_cooldown[w.ID] = w.item.atk_speed[w.level - 1]
