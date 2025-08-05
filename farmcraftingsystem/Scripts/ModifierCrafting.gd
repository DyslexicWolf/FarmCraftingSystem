extends Node

var item_in_slot : ItemResource
var owned_modifiers : Array[Dictionary] = []

func _on_all_new_modifiers_button_pressed() -> void:
	if item_in_slot == null:
		return
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_value = rng.randi_range(1, item_in_slot.max_amount_modifiers)
	
	for i in range(random_value):
		var modifier = Modifiers.get_random_modifier(owned_modifiers)
		owned_modifiers.append(modifier)

func _on_add_one_modifier_button_pressed() -> void:
	if item_in_slot == null or owned_modifiers.size() > 6:
		return
	
	var modifier = Modifiers.get_random_modifier(owned_modifiers)
	owned_modifiers.append(modifier)


func _on_crafting_slot_item_equipped(item: ItemResource) -> void:
	item_in_slot = item


func _on_crafting_slot_item_unequipped(item: ItemResource) -> void:
	item_in_slot = null
