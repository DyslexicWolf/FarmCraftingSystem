extends Node

var inventory_item : InventoryItem
var owned_modifiers : Array[String] = []



#not finished implementing yet
func _on_all_new_modifiers_button_pressed() -> void:
	if inventory_item.item_data == null:
		return
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_value = rng.randi_range(1, inventory_item.item_data.max_amount_modifiers)
	
	for i in range(random_value):
		var modifier = Modifiers.get_random_modifier(owned_modifiers)
		owned_modifiers.append(modifier)

		apply_modifiers_to_item()
#not finished implementing yet




func _on_add_one_modifier_button_pressed() -> void:
	if inventory_item == null or inventory_item.item_data == null or owned_modifiers.size() >= inventory_item.item_data.max_amount_modifiers:
		return
	var modifier: String = Modifiers.get_random_modifier(owned_modifiers)
	owned_modifiers.append(modifier)
	apply_modifiers_to_item()



#not implemented yet
func _on_remove_one_modifier_button_pressed() -> void:
	if inventory_item.item_data == null or owned_modifiers.size() == 0:
		return
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_index = rng.randi_range(0, owned_modifiers.size() - 1)
	var removed_modifier = owned_modifiers[random_index]
	# owned_modifiers.remove(random_index)
	print("Removed modifier: ", removed_modifier)
	print("Current modifiers: ", owned_modifiers)
#not implemented yet



func apply_modifiers_to_item() -> void:
	if inventory_item == null or inventory_item.item_data == null or owned_modifiers.is_empty():
		return
	for modifier in owned_modifiers:
		# Skip already-applied modifiers to avoid double-applying on repeated calls.
		if inventory_item.item_data.modifiers.has(modifier):
			continue
		var modifier_dictionary: Dictionary = Modifiers.normal_modifiers.get(modifier, {})
		if modifier_dictionary.is_empty():
			continue
		var category = modifier_dictionary.get("category", "")
		var value = modifier_dictionary.get("value", 0)
		
		if category == "uses":
			inventory_item.item_data.use_amount += value
		elif category == "yield_mult":
			inventory_item.item_data.yield_multiplier += value
		elif category == "seeds":
			inventory_item.item_data.seeds_amount += value
		elif category == "crit_chance":
			inventory_item.item_data.harvest_crit_chance += value
		elif category == "base_harvest":
			inventory_item.item_data.base_harvest += value
		else:
			continue
		inventory_item.item_data.modifiers.append(modifier)
	inventory_item.update_tooltip()

func _on_crafting_slot_item_equipped(item: InventoryItem) -> void:
	inventory_item = item
	owned_modifiers.clear()
	if inventory_item.item_data != null:
		owned_modifiers = inventory_item.item_data.modifiers.duplicate()


func _on_crafting_slot_item_unequipped(_item: InventoryItem) -> void:
	inventory_item = null
	owned_modifiers.clear()
