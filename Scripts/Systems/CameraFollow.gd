extends Camera2D

@export var target : Node2D
@export var speed : float



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow_target(delta)


func follow_target(delta):
	if target != null:
		var direction = (target.position - position).normalized()
		position = lerp(position, target.position, delta * speed)
