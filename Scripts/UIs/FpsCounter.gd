extends Label
class_name FpsCounter

func _ready() -> void:
	SignalBus.connect("display_fps", toggle_visilibity)

	
func _process(_delta) -> void:
	set_text("FPS %d" % Engine.get_frames_per_second())


func toggle_visilibity(fps_visible : bool) -> void:
	visible = fps_visible
