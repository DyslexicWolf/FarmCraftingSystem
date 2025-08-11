extends TileMapLayer
class_name Farmland

var planted_cells : Dictionary = {}
var harvest_ready_cells : Dictionary = {}
var game : Node2D
@export var max_instances : int = 10
var excess_instances : int

func _ready() -> void:
	var hotbar = get_node("/root/Game/HUD/Hotbar")
	game = get_node("/root/Game")
	hotbar.planted_seeds.connect(_on_planted_seeds)
	hotbar.harvest_mature_crops.connect(_on_harvest_mature_crops)

func _on_planted_seeds(tile_coords, item_data):
	if planted_cells.has(tile_coords):
		return
	set_cell(tile_coords, item_data.planted_tile_id, Vector2i(0, 0))
	
	var timer := Timer.new()
	timer.wait_time = item_data.grow_time / 3.0
	timer.one_shot = false
	timer.connect("timeout", _on_growth_stage.bind(tile_coords, item_data))
	add_child(timer)
	timer.start()
	
	planted_cells[tile_coords] = {
		"item_data": item_data,
		"timer": timer,
		"stage": 0
	}

func _on_harvest_mature_crops(tile_coords : Vector2i):
	var cell_data = harvest_ready_cells.get(tile_coords)
	if cell_data == null:
		return
	var item_data = cell_data.item_data
	var pickup_scene = CropPickups.get_pickup_scene(item_data.base_name)
	if pickup_scene == null:
		push_error("No pickup scene for base_name: %s" % item_data.base_name)
		return
	
	var instance_count : int
	if calculate_harvest_crit(item_data.harvest_crit_chance):
		instance_count = roundi(((item_data.base_harvest + item_data.seeds_amount) * item_data.yield_multiplier) * 2)
	else:
		instance_count = roundi((item_data.base_harvest + item_data.seeds_amount) * item_data.yield_multiplier)
	
	var capped = min(instance_count, max_instances)
	var excess = max(instance_count - max_instances, 0)
	if capped > 0:
		spawn_pickup_items(tile_coords, pickup_scene, capped, 1)
	if excess > 0:
		# one extra pickup with the remaining stack
		spawn_pickup_items(tile_coords, pickup_scene, 1, excess)
	set_cell(tile_coords, 0, Vector2i(0, 0))
	harvest_ready_cells.erase(tile_coords)

func calculate_harvest_crit(crit_chance : int) -> bool:
	var chance = clamp(crit_chance, 0, 100)
	return randi_range(1, 100) <= chance

func spawn_pickup_items(tile_coords : Vector2i, pickup_scene : Resource, instance_count: int, stack_count: int):
	for i in range(instance_count):
		var instance_scene = pickup_scene.instantiate()
		instance_scene.stack_count = stack_count
		var world_pos = self.map_to_local(tile_coords)
		instance_scene.position = world_pos
		add_child(instance_scene)
		
		#these values are for a max offset of 1 tile
		var offset_x = randi_range(-32, 32)
		var offset_y = randi_range(-32, 32)
		var target_pos = world_pos + Vector2(offset_x, offset_y)
		
		var tween = create_tween()
		tween.tween_property(instance_scene, "position", target_pos, 0.3)

func _on_growth_stage(tile_coords : Vector2i, item_data : SeedsResource):
	var cell_data = planted_cells.get(tile_coords)
	if cell_data == null:
		return
	cell_data["stage"] += 1
	var stage = cell_data["stage"]
	
	match stage:
		1:
			set_cell(tile_coords, item_data.growing1_tile_id, Vector2i(0, 0))
		2:
			set_cell(tile_coords, item_data.growing2_tile_id, Vector2i(0, 0))
		3:
			set_cell(tile_coords, item_data.mature_tile_id, Vector2i(0, 0))
			cell_data["timer"].stop()
			cell_data["timer"].queue_free()
			harvest_ready_cells.merge(planted_cells, false)
			planted_cells.erase(tile_coords)
