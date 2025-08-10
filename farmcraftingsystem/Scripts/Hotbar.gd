extends HBoxContainer
class_name Hotbar

signal planted_seeds(cell_coords : Vector2i, item : SeedsResource)

@onready var slots = self.get_children()
var tile_map_layer : TileMapLayer
var active_slot : int = 0
var alpha : float
var camera : Camera2D

func _ready():
	update_highlight()
	tile_map_layer = get_node("/root/Game/Farmland")
	camera = get_node("/root/Game/Player/Camera2D")

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var slots_size = slots.size()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			active_slot = (active_slot + 1) % slots_size
			update_highlight()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			active_slot = (active_slot - 1 + slots_size) % slots_size
			update_highlight()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			use_item()

func update_highlight():
	for i in slots.size():
		alpha = 1.0 if i == active_slot else 0.5
		slots[i].modulate = Color(1, 1, 1, alpha)

func use_item():
	var slot = slots[active_slot]
	if not slot.has_item():
		return
	var inventory_item = slot.get_child(0)
	
	if inventory_item.item_data is not SeedsResource:
		return
	
	var world_pos: Vector2 = camera.get_global_mouse_position()
	
	var local_pos = tile_map_layer.to_local(world_pos)
	var tile_coords = tile_map_layer.local_to_map(local_pos)
	var tile_id = tile_map_layer.get_cell_source_id(tile_coords)
	
	if tile_id == -1:
		return
	
	if tile_id == 0:
		inventory_item.item_data.use_amount -= 1
		if inventory_item.item_data.use_amount == 0:
			slot.get_child(0).queue_free()
		planted_seeds.emit(tile_coords, inventory_item.item_data)
