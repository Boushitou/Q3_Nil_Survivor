class_name EnemySpawner

extends Node

var playerNode : Node2D
var enemies_manager : EnemiesManager

var enemyScene = load("res://Scenes/enemy.tscn")

const max_total_enemies = 300
var max_wave_enemies : int

func set_references(player : Node2D, manager: EnemiesManager):
	playerNode = player 
	enemies_manager = manager


func spawn_enemies_test():
	var rng = RandomNumberGenerator.new()
	var dist = 800.0
	for i in max_total_enemies :
		var pos = Vector2(rng.randf_range(-dist, dist), rng.randf_range(-dist, dist))
		var enemy = PoolSystem.instantiate_object("enemy", enemyScene, pos, 0.0, self)
		enemy.set_references(playerNode, enemies_manager)
