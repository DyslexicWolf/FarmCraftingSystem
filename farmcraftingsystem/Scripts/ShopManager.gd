extends Node2D
class_name ShopManager

var shop_inventory : GridContainer
var hud_manager : HUDManager
var crop_counter_manager : CropCounterManager
var shop_inventory_slot_size : Vector2 = Vector2(96, 128)
var inventory_item_size : Vector2 = Vector2(96, 96)
var starting_items_to_load = [
	"res://Resources/Seeds/CarrotSeeds.tres",
	"res://Resources/Seeds/SweetBeetSeeds.tres",
]

func _ready() -> void:
	shop_inventory = get_node("/root/Game/HUD/ShopInventoryBackground/ShopInventory")
	hud_manager = get_node("/root/Game/HUD")
	crop_counter_manager = get_node("/root/Game/HUD/CropCounterBackground")
	
	for i in starting_items_to_load.size():
		var seeds_resource = load(starting_items_to_load[i])
		var slot: ShopInventorySlot = preload("res://Scenes/ShopInventorySlot.tscn").instantiate()
		
		slot.initialize(seeds_resource.ui_texture, seeds_resource.shop_cost_amount, seeds_resource.shop_cost_texture, shop_inventory_slot_size)
		shop_inventory.add_child(slot)
		var shop_inventory_item = slot.get_child(0)
		shop_inventory_item.initialize(seeds_resource, self, inventory_item_size)


func try_to_buy_item(shop_item : ShopInventoryItem) -> void:
	var counter = crop_counter_manager.find_crop_counter(shop_item.item_data.base_name)
	if counter:
		if counter.crop_count >= shop_item.shop_cost_amount:
			counter.update_count(-shop_item.shop_cost_amount)
			bought_item(shop_item)

func bought_item(shop_item : ShopInventoryItem) -> void:
	var empty_slot = hud_manager.find_empty_inventory_slot()
	var inventory_item = InventoryItem.new()
	inventory_item.initialize(shop_item.item_data, hud_manager, inventory_item_size)
	empty_slot.add_child(inventory_item)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		hud_manager.entered_shop_area()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		hud_manager.exited_shop_area()
