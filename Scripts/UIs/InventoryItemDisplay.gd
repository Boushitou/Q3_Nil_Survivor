extends Panel
class_name InventoryItemDisplay

@export var item_level_label : Label
@export var item_icon : TextureRect

var has_item : bool = false


func _ready() -> void:
	item_level_label.hide()
	item_icon.hide()

	

func set_item_infos(item : Item) -> void :
	if item:
		item_level_label.text = str(item.level)
		item_icon.texture = item.icon
		has_item = true
		item_level_label.show()
		item_icon.show()
	else:
		item_level_label.hide()
		item_icon.hide()
		has_item = false
