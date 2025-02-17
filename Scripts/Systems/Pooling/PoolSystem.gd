extends Node
class_name PoolSystem

static var pool_objects : Array = []

static func instantiate_object(object_name : String, object_to_spawn : PackedScene, object_position : Vector2, object_rotation : float, parent : Node) -> Node:
	var pool = null
	
	for object_info in pool_objects:
		if object_info.object_name == object_name:
			pool = object_info
			#print("Found pool for : ", object_info.object_name)
			break
	
	if pool == null:
		pool = PoolInfoHolder.new(object_name)
		pool_objects.append(pool)
		print("Creating pool for: ", object_name)
		
	var spawned_object = null
	
	for object in pool.inactive_object:
		if object != null:
			spawned_object = object
			break
			
	if spawned_object == null:
		spawned_object = object_to_spawn.instantiate()
		spawned_object.global_position = object_position
		spawned_object.global_rotation = object_rotation
		
		if parent != null:
			parent.add_child(spawned_object)
	
	else:
		spawned_object.global_position = object_position
		spawned_object.global_rotation = object_rotation
		pool.inactive_object.erase(spawned_object)
		spawned_object.visible = true
		spawned_object.process_mode = Node.PROCESS_MODE_INHERIT
		
	return spawned_object


static func pool_object(object_name : String, object_to_pool : Node):
	var pool = null
	
	for object_info in pool_objects:
		if object_info.object_name == object_name:
			pool = object_info
			break
	
	if pool == null:
		print("Trying to release an object that is not pooled: " , object_name)
		object_to_pool.queue_free()
	else:
		object_to_pool.process_mode = Node.PROCESS_MODE_DISABLED
		object_to_pool.visible = false
		pool.inactive_object.append(object_to_pool)
		#print("Release an object that is pooled: " , object_name)
