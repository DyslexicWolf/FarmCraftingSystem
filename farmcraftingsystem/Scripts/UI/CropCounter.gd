extends Panel
class_name CropCounter

var crop_name : String = ""
var crop_image : Texture2D
var crop_count : int = 0
var label : Label
var texture_rect : TextureRect

func _ready() -> void:
	label = $Label
	texture_rect = $TextureRect
	label.visible = false
	texture_rect.visible = false

func _on_first_pickup(item_data : CropResource, amount : int):
	crop_name = item_data.base_name
	crop_image = item_data.ui_texture
	crop_count = amount
	label.visible = true
	texture_rect.visible = true
	_update_display()

func _on_add_to_count(amount : int):
	crop_count += amount
	_update_display()

func _update_display():
	$Label.text = str(crop_count, "x")
	$TextureRect.texture = crop_image
