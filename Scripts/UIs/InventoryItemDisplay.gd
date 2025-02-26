extends Panel
class_name InventoryItemDisplay

@export var item_level_label : Label
@export var item_icon : TextureRect

var item_displayed : Items = null


func _ready() -> void:
	item_level_label.hide()
	item_icon.hide()
	

func set_item_infos(item : Items) -> void :
	if item:
		item_level_label.text = str(item.level)
		item_icon.texture = item.item.sprite
		item_displayed = item
		item_level_label.show()
		item_icon.show()
	else:
		item_level_label.hide()
		item_icon.hide()
		item_displayed = null
