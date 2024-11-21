class_name Enemy

extends Area2D

var enemies_manager : EnemiesManager

var playerNode : Node2D
var separation_radius : float
var separation_force : Vector2 = Vector2.ZERO

@export var separation_weight : float
@export var stats : Stats

var collider : CollisionShape2D

var grid_size = 50
var last_cell : Vector2 = Vector2(-1, 1)

var update_frequency = 0.1 #10fps
var time_since_last_update = 0.0

func _ready():
	add_to_group("enemies")
	collider = $CollisionShape2D
	
	set_separation_radius()


func _process(delta):
	if !enemies_manager:
		return
	
	update_grid_position()
	follow_player(delta)


func set_references(player : Node2D, manager: EnemiesManager):
	playerNode = player
	enemies_manager = manager
	
	
func setup_stats(enemy_stat):
	stats.health.total_health = enemy_stat["total_health"]
	stats.power = enemy_stat["power"]
	stats.speed = enemy_stat["speed"]


func follow_player(delta):
	var direction = (playerNode.global_position - global_position).normalized()
	
	time_since_last_update += delta

	if time_since_last_update >= update_frequency:
		var neighbors_positions = get_neighbors_positions()
		separation_force = get_separation_force(global_position, neighbors_positions)
		time_since_last_update = 0.0
	
	var movement = (direction + separation_force * separation_weight).normalized()
	
	position += (stats.speed * delta) * movement


#make enemies avoid each other
func get_separation_force(current_position : Vector2, neighbor_positions : Array) -> Vector2:
	var force = Vector2.ZERO
	
	for neighbor_position in neighbor_positions:
		var distance = current_position.distance_squared_to(neighbor_position)
		if distance < separation_radius * separation_radius:
			var push_direction = (current_position - neighbor_position).normalized()
			
			if push_direction.length() == 0:
				push_direction = Vector2(randf() - 0.5, randf() - 0.5).normalized()
			else:
				force += push_direction / sqrt(distance)
	
	return force


func set_separation_radius():
	if !collider:
		return
	
	var shape = collider.get_shape()
	
	if shape is CircleShape2D:
		var circle_shape = shape as CircleShape2D
		separation_radius = circle_shape.radius * 2
	else:
		print("Set a circle shape for this node !")


func update_grid_position():
	var current_cell = Vector2(int(global_position.x / grid_size), int(global_position.y / grid_size))
	
	if current_cell != last_cell:
		if last_cell != Vector2(-1 , -1): #skip first update
			enemies_manager.update_enemy_position(self, last_cell, current_cell)
		
		last_cell = current_cell


func get_neighbors_positions() -> Array:
	var neighbors = enemies_manager.get_nearby_enemies(last_cell)
	var neighbor_position = []
	for neighbor in neighbors:
		if is_instance_valid(neighbor):
			neighbor_position.append(neighbor.global_position)
		
	return neighbor_position


func get_damage():
	return stats.power


func _on_mouse_entered():
	enemies_manager.remove_enemy(self, last_cell)
