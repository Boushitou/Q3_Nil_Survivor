extends Label

func _process(_delta) -> void:
	set_text("FPS %d" % Engine.get_frames_per_second())
