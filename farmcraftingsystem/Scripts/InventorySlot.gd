extends PanelContainer
class_name InventorySlot

signal item_unequipped(item : ItemResource)

func initialize(cms: Vector2) -> void:
	custom_minimum_size = cms

# Checks if the dragged item can be dropped into this slot
func _can_drop_data(_at_position: Vector2, data: Variant):
	if data is InventoryItem:
			return true
	return false

func _drop_data(_at_position: Vector2, data: Variant):
	if data is InventoryItem:
		var old_slot = data.get_parent()
		if self is InventorySlot or old_slot is InventorySlot or old_slot is CraftingSlot:
			if old_slot == self:
				return
			
			#cant use old_slot here since we dont know what the current parent is of data
			if data.get_parent():
				data.get_parent().remove_child(data)
			
			#if there is an existing item switch it with the dragged item
			if get_child_count() > 0:
				var existing_item = get_child(0)
				remove_child(existing_item)
				old_slot.add_child(existing_item)
				if old_slot is CraftingSlot:
					item_unequipped.emit(existing_item)
			
			if old_slot is CraftingSlot:
				item_unequipped.emit(data)
			add_child(data)
