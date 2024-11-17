class_name EnemySpawner

extends Node

var playerNode : Node2D
var enemies_manager : EnemiesManager

var enemyScene = load("res://Scenes/enemy.tscn")

var enemy_frequency = 0.001
var time_since_last_spawn = 0.0

const max_total_enemies = 300
var max_wave_enemies : int

func _process(delta):
	if enemies_manager.get_enemy_count() < max_total_enemies:
		time_since_last_spawn += delta
		if time_since_last_spawn >= enemy_frequency:
			spawn_enemies_test()
			time_since_last_spawn = 0.0
			print(enemies_manager.get_enemy_count())


func set_references(player : Node2D, manager: EnemiesManager):
	playerNode = player 
	enemies_manager = manager


func spawn_enemies_test():
	var rng = RandomNumberGenerator.new()
	var dist = 800.0
	var pos = Vector2(rng.randf_range(-dist, dist), rng.randf_range(-dist, dist))
	var enemy = PoolSystem.instantiate_object("enemy", enemyScene, pos, 0.0, self)
	enemy.set_references(playerNode, enemies_manager)