extends TextureRect
class_name InventoryItem

@export var item_data : ItemResource
var inventory_manager : InventoryManager
var stack_count : int = 1

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

func initialize(d: ItemResource, im : InventoryManager, count: int = 1) -> void:
	item_data = d
	stack_count = count
	texture = item_data.ui_texture
	inventory_manager = im
	update_tooltip()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Input.is_action_pressed("shift"):
			if inventory_manager != null:
				inventory_manager.shift_click_item(self)

func update_tooltip():
	if item_data != null:
		if item_data is CropResource:
			tooltip_text = "%s\n%d\n%s" %  [item_data.name, stack_count, item_data.description]
		
		if item_data is SeedsResource:
			var modifiers_text = ""
			for modifier in item_data.modifiers:
				modifiers_text += str(modifier) + ", "

			if modifiers_text.length() > 0:
				modifiers_text = modifiers_text.substr(0, modifiers_text.length() - 2)
			tooltip_text = "%s\n%s\n%s" % [item_data.name, modifiers_text, item_data.description]

func is_stackable_with(item: Variant) -> bool:
	return item_data is CropResource and item is CropResource and item.base_name == item_data.base_name

func add_to_stack(amount: int) -> bool:
	if not (item_data is CropResource):
		return false
	if amount <= 0:
		return false
	var max_stack_count = item_data.max_stack_count
	if stack_count >= max_stack_count:
		return false
	var target := stack_count + amount
	var fully_added = target <= max_stack_count
	stack_count = min(target, max_stack_count)
	update_tooltip()
	return fully_added

func _get_drag_data(at_position: Vector2):
	set_drag_preview(make_drag_preview(at_position))
	return self

func make_drag_preview(at_position: Vector2):
	var t := TextureRect.new()
	t.texture = item_data.ui_texture
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.custom_minimum_size = size
	t.modulate.a = 0.5
	t.position = Vector2(-at_position)
	
	var c := Control.new()
	c.add_child(t)
	return c
