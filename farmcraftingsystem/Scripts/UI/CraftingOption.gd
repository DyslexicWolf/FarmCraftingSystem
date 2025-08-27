extends Button

signal crafting_option_selected(crafting_id_name : String, index : int)
@export var crafting_option_index : int
@export var crafting_id_name : String

func _ready() -> void:
	self.pressed.connect(_on_pressed)
	var crafting_option_list = get_parent().get_parent()
	crafting_option_selected.connect(crafting_option_list.on_crafting_option_pressed)

func _on_pressed() -> void:
	crafting_option_selected.emit(crafting_id_name, crafting_option_index)
