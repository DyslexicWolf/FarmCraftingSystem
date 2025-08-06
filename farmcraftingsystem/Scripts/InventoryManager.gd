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
		slot.connect("item_unequipped", _on_item_unequipped)
	
	for i in temp_items_load_fortesting.size():
		var item_resource = load(temp_items_load_fortesting[i])
		var item := InventoryItem.new()
		item.initialize(item_resource)
		inventory.get_child(i).add_child(item)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_inventory") and inventory_background.visible == false:
		inventory_background.visible = true
	elif Input.is_action_just_pressed("close_inventory") and inventory_background.visible == true:
		inventory_background.visible = false
	if Input.is_action_just_pressed("open_crafting_menu") and crafting_background.visible == false:
		crafting_background.visible = true
	elif Input.is_action_just_pressed("close_crafting_menu") and crafting_background.visible == true:
		crafting_background.visible = false
	
	#unsure on where and how to implement this logic, here or in inventory item script
	if Input.is_action_pressed("shift") and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		pass

func _on_item_unequipped(item: InventoryItem) -> void:
	crafting_item_unequipped.emit(item)

func _on_picked_up_item(picked_up_item: ItemResource) -> void:
	# Check if there is an empty slot in the inventory
	for i in range(inventory.get_child_count()):
		var slot = inventory.get_child(i)
		if slot.get_child_count() == 0:
			var item := InventoryItem.new()
			item.initialize(picked_up_item)
			slot.add_child(item)
			return
	
	var new_item := InventoryItem.new()
	new_item.initialize(picked_up_item)
	inventory.get_child(0).add_child(new_item)
