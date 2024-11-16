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
		var enemy = enemyScene.instantiate()
		add_child(enemy)
		var pos = Vector2(rng.randf_range(-dist, dist), rng.randf_range(-dist, dist))
		enemy.global_position = pos
		enemy.set_references(playerNode, enemies_manager)
