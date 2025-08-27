extends ScrollContainer
class_name CraftingOptionList

signal option_selected(id_name : String)

var crafting_option_buttons : Array[Node] = []
var vbox_container : VBoxContainer
var crafting_option_scene = preload("res://Scenes/CraftingOption.tscn")
var current_crafting_option_index : int = -1

func _ready() -> void:
	vbox_container = get_child(0)
	crafting_option_buttons = vbox_container.get_children()
	
	var keys : Array = CraftingOptions.crafting_options.keys()
	var keys_size = keys.size()
	var crafting_option_buttons_size = crafting_option_buttons.size()
	
	if keys_size != crafting_option_buttons_size:
		if keys_size > crafting_option_buttons_size:
			var diff = crafting_option_buttons_size - keys_size
			for i in range(diff):
				var scene_instance = crafting_option_scene.instantiate()
				vbox_container.add_child(scene_instance)
		elif keys_size < crafting_option_buttons_size:
			var diff = crafting_option_buttons_size - keys_size
			for i in range(diff):
				var last_child = vbox_container.get_child(vbox_container.get_child_count() - 1)
				vbox_container.remove_child(last_child)
				last_child.queue_free()
	
	for i in range(keys.size()):
		var element_key = keys[i]
		var button = crafting_option_buttons[i]
		
		button.icon = CraftingOptions.crafting_options[element_key]["icon"]
		var rich_text : RichTextLabel = button.get_child(0)
		
		rich_text.text = CraftingOptions.crafting_options[element_key]["text"]
		button.custom_minimum_size.y = rich_text.get_content_height() + 25
		rich_text.custom_minimum_size.y = rich_text.get_content_height() + 25
		button.crafting_id_name = CraftingOptions.crafting_options[element_key]["id_name"]


func on_crafting_option_pressed(id_name : String, index : int) -> void:
	if index == current_crafting_option_index:
		return
	current_crafting_option_index = index
	option_selected.emit(id_name)
