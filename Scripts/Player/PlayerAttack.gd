extends Node
class_name PlayerAttack

@export var inventory : Inventory
@export var player_stats : PlayerStats

var weapons : Array[Items]
var weapons_cooldown : Dictionary = {}

func _ready() -> void:
	weapons = inventory.weapons
	SignalBus.connect("get_new_weapon", add_weapon)
	
	set_weapons_cooldown()
	
	
func _process(delta: float) -> void:
	for w in weapons:
		if w.item is Weapon:
			weapons_cooldown[w.item.ID] -= delta
			attack()
	

func add_weapon(weapon: Items) -> void:
	weapons.append(weapon)
	weapons_cooldown[weapon.item.ID] = weapon.item.atk_speed[weapon.level - 1]
	weapon.apply_effects()

	
func attack() -> void:
	for w in weapons:
		if not w.item is Weapon:
			continue
		if weapons_cooldown[w.item.ID] <= 0.0:
			print("attacking !")
			w.apply_effects()
			weapons_cooldown[w.item.ID] = w.item.atk_speed[w.level - 1]
			
			
		
func set_weapons_cooldown() -> void:
	for w in weapons:
		if w.item is Weapon:
			weapons_cooldown[w.item.ID] = w.item.atk_speed[w.level - 1]
