extends TextureProgressBar
class_name SmoothProgressBar

var current_value : float
var target_value : float


func _process(delta: float) -> void:
	if current_value != target_value:
		current_value = Utilities.smooth_fill(current_value, target_value, 10, delta)
		self.value = current_value