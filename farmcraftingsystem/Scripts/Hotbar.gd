extends HBoxContainer

@onready var slots = self.get_children()
var tilemap : TileMapLayer
var active_slot : int = 0
var alpha : float

func _ready():
	update_highlight()
	tilemap = get_node("/root/Game/TileMapLayer")

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
		alpha = 0.5 if i == active_slot else 1
		slots[i].modulate = Color(1, 1, 1, alpha)

func use_item():
	var slot = slots[active_slot]
	if not slot.has_item():
		return
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	var local_pos = tilemap.to_local(mouse_pos)
	var tile_coords = tilemap.local_to_map(local_pos)
	var tile_id = tilemap.get_cell_source_id(tile_coords)
	
	if tile_id == -1:
		return
	
	if tile_id == 1:
		print("farmland")
