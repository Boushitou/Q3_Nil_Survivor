class_name EnemySpawner

extends Node

var playerNode : Node2D
var enemies_manager : EnemiesManager

var enemyScene = load("res://Scenes/enemy.tscn")
var enemy_data = {}
var enemies_waves = []

var enemy_frequency = 0.001
var time_since_last_spawn = 0.0

const max_total_enemies = 5
var max_wave_enemies : int

var rng = RandomNumberGenerator.new()


func _ready():
	var file = FileAccess.open("res://Data/Enemies/enemies.json", FileAccess.READ)
	if file:
		enemy_data = JSON.parse_string(file.get_as_text())
		file.close()


func _process(delta):
	if enemies_manager.get_enemy_count() < max_total_enemies:
		time_since_last_spawn += delta
		if time_since_last_spawn >= enemy_frequency:
			spawn_enemies_test()
			time_since_last_spawn = 0.0


func set_references(player : Node2D, manager: EnemiesManager):
	playerNode = player 
	enemies_manager = manager


func spawn_enemies_test():
	var dist = 800.0
	var pos = Vector2(rng.randf_range(-dist, dist), rng.randf_range(-dist, dist))
	var enemy = PoolSystem.instantiate_object("enemy", enemyScene, pos, 0.0, self)
	enemy.set_references(playerNode, enemies_manager)
	enemy.setup_stats(enemy_data["mummy"])
