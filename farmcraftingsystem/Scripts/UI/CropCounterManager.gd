extends Panel

var crop_counters : Array[Panel] = []

func _ready() -> void:
	for child in get_children():
		if child is CropCounter:
			crop_counters.append(child)

func _on_picked_up_crop(item: ItemResource, stack_count: int) -> void:
	var crop_counter = _find_crop_counter(item.base_name)
	if crop_counter:
		# Already tracking this crop → just add
		crop_counter._on_add_to_count(stack_count)
	else:
		# Need to assign a new counter
		var free_crop_counter := _find_free_crop_counter()
		if free_crop_counter:
			free_crop_counter._on_first_pickup(item, stack_count)
		else:
			print("to many items, too little counters, no free counter anymore")

func _find_crop_counter(base_name : String) -> CropCounter:
	for crop_counter in crop_counters:
		if crop_counter.crop_name == base_name:
			return crop_counter
	return null

func _find_free_crop_counter() -> CropCounter:
	for crop_counter in crop_counters:
		if crop_counter.crop_name == "":
			return crop_counter
	return null
