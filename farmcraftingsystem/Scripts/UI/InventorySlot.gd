extends PanelContainer
class_name InventorySlot

signal item_unequipped(item : ItemResource)
var stack_count_label = Label

func initialize(cms: Vector2) -> void:
	custom_minimum_size = cms
	stack_count_label = Label.new()
	stack_count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	stack_count_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	self.add_child(stack_count_label)

# Checks if the dragged item can be dropped into this slot
func _can_drop_data(_at_position: Vector2, data: Variant):
	if data is InventoryItem:
			return true
	return false

func _drop_data(_at_position: Vector2, data: Variant):
	if data is InventoryItem:
		var old_slot = data.get_parent()
		if old_slot == self:
			return
		
		#if there is an existing item switch it with the dragged item
		if get_child_count() > 1:
			var existing_item = get_child(1)
			if existing_item is InventoryItem and existing_item.is_stackable_with(data):
				existing_item.add_to_stack(data.stack_count)
				if data.get_parent():
					data.get_parent().remove_child(data)
				data.queue_free()
				return
			else:
				remove_child(existing_item)
				old_slot.add_child(existing_item)
				if old_slot is CraftingSlot:
					item_unequipped.emit(existing_item)
		
		#cant use old_slot here since we dont know what the current parent is of data
		if data.get_parent():
			data.get_parent().remove_child(data)
		if old_slot is CraftingSlot:
			item_unequipped.emit(data)
		old_slot.update_stack_count_label(0)
		add_child(data)
		update_stack_count_label(data.stack_count)

func update_stack_count_label(count : int):
	if count > 1:
		stack_count_label.text = str(count)
		stack_count_label.visible = true
	else:
		stack_count_label.visible = false
