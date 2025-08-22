extends Panel
class_name ModifierCrafting

var inventory_item : InventoryItem
var owned_modifiers : Array[String] = []
enum Rarity {normal, magic, rare, epic, legendary}


func _on_all_new_modifiers_button_pressed() -> void:
	if inventory_item == null or inventory_item.item_data == null :
		return
	
	if inventory_item.item_data.rarity != Rarity.normal:
		return
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var amount_to_be_added = rng.randi_range(1, inventory_item.item_data.max_amount_modifiers)
	for i in range(amount_to_be_added):
		var modifier = Modifiers.get_random_modifier(owned_modifiers)
		owned_modifiers.append(modifier)
		apply_modifiers_to_item(modifier)

func _on_add_one_modifier_button_pressed() -> void:
	if inventory_item == null or inventory_item.item_data == null or owned_modifiers.size() >= inventory_item.item_data.max_amount_modifiers:
		return
	var modifier: String = Modifiers.get_random_modifier(owned_modifiers)
	owned_modifiers.append(modifier)
	apply_modifiers_to_item(modifier)

func _on_remove_one_modifier_button_pressed() -> void:
	if inventory_item.item_data == null or owned_modifiers.size() == 0:
		return
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_index = rng.randi_range(0, owned_modifiers.size() - 1)
	var removed_modifier = owned_modifiers[random_index]
	owned_modifiers.remove_at(random_index)
	inventory_item.item_data.modifiers.erase(removed_modifier)
	
	print("Removed modifier: ", removed_modifier)
	print("Current modifiers: ", owned_modifiers)
	inventory_item.update_tooltip()

func apply_modifiers_to_item(new_modifier : String) -> void:
	if inventory_item == null or inventory_item.item_data == null:
		return
	var modifiers_to_apply = []
	if new_modifier != "":
		modifiers_to_apply.append(new_modifier)
	else:
		modifiers_to_apply = owned_modifiers
	for modifier in modifiers_to_apply:
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
