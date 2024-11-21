class_name EnemiesManager

extends Node

var player_pos : Node2D
var spawner : EnemySpawner

var enemy_grid : Dictionary = {}

func _ready():
	player_pos = $"../Controller/Body"
	spawner = $EnemySpawner
	spawner.set_references(player_pos, self)
	spawner.spawn_enemies_test()


func update_enemy_position(enemy: Node, old_cell: Vector2, new_cell: Vector2):
	var old_cell_enemies = enemy_grid.get(old_cell, [])
	old_cell_enemies.erase(enemy)
	
	var new_cell_enemies = enemy_grid.get(new_cell, [])
	new_cell_enemies.append(enemy)
	enemy_grid[new_cell] = new_cell_enemies


func get_enemies_in_cell(cell: Vector2) -> Array:
	return enemy_grid.get(cell, [])


func get_nearby_enemies(cell: Vector2) -> Array:
	var nearby_enemies = []
	
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			var neighbor_cell = cell + Vector2(dx, dy)
			nearby_enemies += get_enemies_in_cell(neighbor_cell)
			
	return nearby_enemies


func remove_enemy(enemy: Node, cell: Vector2):
	var cell_enemies = enemy_grid.get(cell, [])
	cell_enemies.erase(enemy)
	enemy_grid[cell] = cell_enemies
	PoolSystem.pool_object("enemy", enemy)


func get_enemy_count() -> int:
	var count = 0
	
	for cell_enemies in enemy_grid.values():
		count += cell_enemies.size()
	
	return count
