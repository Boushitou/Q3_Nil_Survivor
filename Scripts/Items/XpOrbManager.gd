extends Node
class_name XpOrbManager

var orb : Resource = preload("res://Scenes/xp_orb.tscn")

var xp_orb_nb : int = 0
const MAX_ORB_NB : int = 400
var enemies_manager : EnemiesManager

var player_node : Node2D
var camera : Camera2D
var max_distance : float = 500

var orbs : Array[Experience]

var orbs_value : int = 2

func _ready() -> void:
	enemies_manager = get_parent()
	enemies_manager.connect("enemy_died_signal", spawn_orb)
	player_node = $"../../Player/Body"
	camera = player_node.get_viewport().get_camera_2d()
	

func _process(_delta: float) -> void:
	if orbs.size() > 0:
		relocate_orbs()


func spawn_orb(position : Vector2, _enemy_type : int) -> void:
	if xp_orb_nb < MAX_ORB_NB:
		var new_orb : Experience = PoolSystem.instantiate_object("xp_orb", orb, position, 0.0, self)
		new_orb.value = 1000 #because they don't get destroyed they keep the old value so we initialize them
		orbs.append(new_orb)
		xp_orb_nb += 1
	else:
		add_value_to_orb()

	
func add_value_to_orb() -> void:
	var rnd_index : int = randi_range(0, get_child_count() - 1)
	var rnd_orb : Experience = get_child(rnd_index)
	
	rnd_orb.value += orbs_value


func remove_orb(orb_to_remove : Experience) -> void:
	if orbs.size() > 0:
		orbs.erase(orb_to_remove)
	xp_orb_nb -= 1
	
	if xp_orb_nb < 0:
		xp_orb_nb = 0


#if the orbs are too far away we get them closer to the player
func relocate_orbs() -> void:
	if player_node == null:
		return
		
	for o in orbs:
		var distance_to_player : float = o.global_position.distance_squared_to(player_node.global_position)
		var distance_respawn : float = camera.get_spawn_distance(50)

		if distance_to_player > distance_respawn * distance_respawn + max_distance:
			var new_pos : Vector2 = camera.get_spawn_position(distance_respawn)
			o.global_position = new_pos


func _exit_tree() -> void:
	enemies_manager.disconnect("enemy_died_signal", spawn_orb)
