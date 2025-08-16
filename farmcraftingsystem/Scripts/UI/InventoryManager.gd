extends CanvasLayer
class_name InventoryManager

signal crafting_item_unequipped(item : ItemResource)

var inventory_size = 21
var inventory : GridContainer
var inventory_background : Panel
var crafting_background : Panel
var temp_items_load_fortesting = [
	"res://Resources/Seeds/CarrotSeeds.tres",
	"res://Resources/Seeds/SweetBeetSeeds.tres",
]

func _ready():
	inventory = $InventoryBackground/Inventory
	inventory_background = $InventoryBackground
	crafting_background = $CraftingBackground
	
	for i in inventory_size:
		var slot := InventorySlot.new()
		slot.initialize(Vector2(64, 64))
		inventory.add_child(slot)
		slot.add_to_group("InventorySlot")
		slot.connect("item_unequipped", _on_item_unequipped)
	
	for i in temp_items_load_fortesting.size():
		var item_resource = load(temp_items_load_fortesting[i])
		var inventory_item := InventoryItem.new()
		inventory_item.initialize(item_resource, self)
		inventory.get_child(i).add_child(inventory_item)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_inventory") and inventory_background.visible == false:
		inventory_background.visible = true
	elif Input.is_action_just_pressed("close_inventory") and inventory_background.visible == true:
		inventory_background.visible = false
	if Input.is_action_just_pressed("open_crafting_menu") and crafting_background.visible == false:
		crafting_background.visible = true
	elif Input.is_action_just_pressed("close_crafting_menu") and crafting_background.visible == true:
		crafting_background.visible = false
	
func shift_click_item(inventory_item: InventoryItem) -> void:
	var current_slot = inventory_item.get_parent()
	var target_slot = null

	if current_slot.is_in_group("CraftingSlot") and inventory_background.visible:
		target_slot = find_empty_inventory_slot()
	elif current_slot.is_in_group("InventorySlot"):
		if crafting_background.visible:
			target_slot = find_empty_crafting_slot()
		else:
			target_slot = find_empty_hotbar_slot()
	elif current_slot.is_in_group("HotbarSlot") and inventory_background.visible:
		target_slot = find_empty_inventory_slot()
	
	if target_slot:
		current_slot.remove_child(inventory_item)
		target_slot.add_child(inventory_item)

func find_empty_inventory_slot() -> InventorySlot:
	for slot in inventory.get_children():
		if slot.get_child_count() == 1:
			return slot
	return null

func find_empty_crafting_slot() -> InventorySlot:
	var crafting_slot = crafting_background.get_child(0)
	if crafting_slot:
		if crafting_slot.get_child_count() == 1:
			return crafting_slot
	return null

func find_empty_hotbar_slot() -> InventorySlot:
	var hotbar_slots = $Hotbar.get_children()
	for slot in hotbar_slots:
		if slot.get_child_count() == 1:
			return slot
	return null

func _on_item_unequipped(inventory_item: InventoryItem) -> void:
	crafting_item_unequipped.emit(inventory_item)

func _on_picked_up_item(picked_up_item: ItemResource, stack_count : int) -> void:
	var leftover = stack_count
	while leftover > 0:
		var placed_in_stack := false
		
		# First pass: try to stack onto existing items
		for i in range(inventory.get_child_count()):
			var slot = inventory.get_child(i)
			if slot.get_child_count() == 2 and slot.get_child(1) is InventoryItem:
				var item = slot.get_child(1)
				if item.is_stackable_with(picked_up_item):
					var result = item.add_to_stack(leftover)
					var added_successfully = result[0]
					leftover = result[1]
					if added_successfully:
						slot.update_stack_count_label(item.stack_count)
					if leftover <= 0:
						return
					placed_in_stack = true
		
		# If nothing could be stacked, try to place in a free slot
		var found_empty := false
		
		if not placed_in_stack:
			for i in range(inventory.get_child_count()):
				var slot = inventory.get_child(i)
				if slot.get_child_count() == 1:
					var item := InventoryItem.new()
					item.initialize(picked_up_item, self)
					if leftover > 1:
						var result = item.add_to_stack(leftover)
						leftover = result[1]
					else:
						leftover = 0
					slot.add_child(item)
					slot.update_stack_count_label(item.stack_count)
					found_empty = true
					break
		if found_empty and leftover <= 0:
			return
			
			# If no empty slots exist → stop (inventory full)
			if not found_empty:
				print("Inventory full! Leftover: ", leftover)
				return
