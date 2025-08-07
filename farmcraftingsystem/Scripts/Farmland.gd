extends TileMapLayer
class_name Farmland

var planted_cells : Dictionary = {}

func _ready() -> void:
	var hotbar = get_node("/root/Game/HUD/Hotbar")
	hotbar.planted_seeds.connect(_on_planted_seeds)

func _on_planted_seeds(cell_coords, item_data):
	if planted_cells.has(cell_coords):
		return
	set_cell(cell_coords, item_data.planted_tile_id, Vector2i(0, 0))
	
	var timer := Timer.new()
	timer.wait_time = item_data.grow_time / 3.0
	timer.one_shot = false
	timer.connect("timeout", _on_growth_stage.bind(cell_coords, item_data))
	add_child(timer)
	timer.start()
	
	planted_cells[cell_coords] = {
		"item_data": item_data,
		"timer": timer,
		"stage": 0
	}

func _on_growth_stage(cell_coords : Vector2i, item_data : SeedsResource):
	var cell_data = planted_cells.get(cell_coords)
	if cell_data == null:
		return
	cell_data["stage"] += 1
	var stage = cell_data["stage"]
	
	match stage:
		1:
			set_cell(cell_coords, item_data.growing1_tile_id, Vector2i(0, 0))
		2:
			set_cell(cell_coords, item_data.growing2_tile_id, Vector2i(0, 0))
		3:
			set_cell(cell_coords, item_data.mature_tile_id, Vector2i(0, 0))
			cell_data["timer"].stop()
			cell_data["timer"].queue_free()
			planted_cells.erase(cell_coords)
