class_name XpOrbManager

extends Node

var orb = preload("res://Scenes/xp_orb.tscn")

var xp_orb_nb = 0
const MAX_ORB_NB = 3
var enemies_manager : EnemiesManager

func _ready() -> void:
	enemies_manager = get_parent()
	enemies_manager.connect("enemy_died_signal", spawn_orb)
	

func spawn_orb(position : Vector2):
	if xp_orb_nb < MAX_ORB_NB:
		PoolSystem.instantiate_object("xp_orb", orb, position, 0.0, self)
		xp_orb_nb += 1
	else:
		add_value_to_orb()

	
func add_value_to_orb():
	var rnd_index = randi_range(0, get_child_count() - 1)
	var rnd_orb : Experience = get_child(rnd_index)
	
	rnd_orb.value += 2


func remove_orb():
	xp_orb_nb -= 1


func _exit_tree() -> void:
	enemies_manager.disconnect("enemy_died_signal", spawn_orb)
