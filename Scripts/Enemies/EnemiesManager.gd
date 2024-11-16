class_name EnemiesManager

extends Node

var player_pos : Node2D
var spawner : EnemySpawner

var enemy_grid : Dictionary = {}

func _ready():
	player_pos = $"../Controller/Player"
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
