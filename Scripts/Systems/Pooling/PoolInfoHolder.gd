extends Node
class_name PoolInfoHolder

var object_name : String
var inactive_object : Array

func _init(new_name : String) -> void:
	object_name = new_name
	inactive_object = []
