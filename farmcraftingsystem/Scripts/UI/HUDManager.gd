extends CanvasLayer
class_name HUDManager

signal crafting_item_unequipped(item : InventoryItem)
signal crafting_item_equipped(item : InventoryItem)
signal picked_up_crop(item : ItemResource, stack_count : int)

var inventory_size = 21
var inventory : GridContainer
var inventory_background : Panel
var crafting_background : Panel
var crafting_slot_background : Panel
var shop_inventory_background : Panel
var popup_text : RichTextLabel
var slot_and_item_size : Vector2 = Vector2(96, 96)
var centered_position : Vector2 = Vector2(539, 351)
var centered_right_position : Vector2 = Vector2(950, 351)
var temp_items_load_fortesting = [
	"res://Resources/Seeds/CarrotSeeds.tres",
	"res://Resources/Seeds/SweetBeetSeeds.tres",
]

func _ready():
	inventory = $InventoryBackground/Inventory
	inventory_background = $InventoryBackground
	crafting_background = $CraftingBackground
	crafting_slot_background = $CraftingBackground/SlotBackground
	shop_inventory_background = $ShopInventoryBackground
	popup_text = $PopupText
	
	for i in inventory_size:
		var slot := InventorySlot.new()
		slot.initialize(slot_and_item_size)
		inventory.add_child(slot)
		slot.add_to_group("InventorySlot")
		slot.connect("item_unequipped", _on_item_unequipped)
	
	for i in temp_items_load_fortesting.size():
		var item_resource = load(temp_items_load_fortesting[i])
		var inventory_item := InventoryItem.new()
		inventory_item.initialize(item_resource, self, slot_and_item_size)
		inventory.get_child(i).add_child(inventory_item)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_inventory") and inventory_background.visible == false:
		inventory_background.visible = true
	elif Input.is_action_just_pressed("close_inventory") and inventory_background.visible == true:
		inventory_background.visible = false
	if Input.is_action_just_pressed("open_crafting_menu") and crafting_background.visible == false:
		crafting_background.visible = true
		inventory_background.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
		inventory_background.position = centered_right_position
	elif Input.is_action_just_pressed("close_crafting_menu") and crafting_background.visible == true:
		crafting_background.visible = false
		inventory_background.set_anchors_preset(Control.PRESET_CENTER)
		inventory_background.position = centered_position
	if Input.is_action_just_pressed("open_shop_inventory") and shop_inventory_background.visible == false:
		shop_inventory_background.visible = true
		inventory_background.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
		inventory_background.position = centered_right_position

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
		if target_slot is CraftingSlot:
			crafting_item_equipped.emit(inventory_item)

func find_empty_inventory_slot() -> InventorySlot:
	for slot in inventory.get_children():
		if slot.get_child_count() == 0:
			return slot
	return null

func find_empty_crafting_slot() -> CraftingSlot:
	var crafting_slot = crafting_slot_background.get_child(0)
	if crafting_slot:
		if crafting_slot.get_child_count() == 0:
			return crafting_slot
	return null

func find_empty_hotbar_slot() -> HotbarSlot:
	var hotbar_slots = $Hotbar.get_children()
	for slot in hotbar_slots:
		if slot.get_child_count() == 0:
			return slot
	return null

func entered_shop_area():
	popup_text.visible = true
	
	#can use BBCode for the text
	popup_text.text = "Press H to open the shop inventory"

func exited_shop_area():
	popup_text.visible = false
	shop_inventory_background.visible = false
	inventory_background.set_anchors_preset(Control.PRESET_CENTER)
	inventory_background.position = centered_position

func _on_item_unequipped(inventory_item: InventoryItem) -> void:
	crafting_item_unequipped.emit(inventory_item)

func _on_player_picked_up_crop(item: ItemResource, stack_count: int) -> void:
	picked_up_crop.emit(item, stack_count)
