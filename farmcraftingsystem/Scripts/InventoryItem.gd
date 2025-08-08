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
			tooltip_text = "%s x%d\n%s" %  [item_data.name, stack_count, item_data.description]
		if item_data is SeedsResource:
			tooltip_text = "%s %s" %  [item_data.name, item_data.description]

func is_stackable_with(other: InventoryItem) -> bool:
	return item_data is CropResource and other.item_data == item_data

func add_to_stack(amount : int):
	stack_count += amount
	update_tooltip()

func _get_drag_data(at_position: Vector2):
	set_drag_preview(make_drag_preview(at_position))
	return self

func make_drag_preview(at_position: Vector2):
	var t := TextureRect.new()
	t.texture = item_data.ui_texture
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.custom_minimum_size = size
	t.modulate.a = 0.5
	t.position = Vector2(-at_position)
	
	var c := Control.new()
	c.add_child(t)
	return c
