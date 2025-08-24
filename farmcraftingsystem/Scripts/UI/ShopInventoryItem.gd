extends TextureRect
class_name ShopInventoryItem

var item_data : ItemResource
var custom_tooltip_text : String
var tooltip_scene = preload("res://Scenes/CustomTooltip.tscn")
var shop_manager : ShopManager
var shop_cost_amount : int
var shop_cost_type : String

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

func initialize(data: SeedsResource, sm : ShopManager, cms : Vector2) -> void:
	custom_minimum_size = cms
	item_data = data
	shop_cost_amount = item_data.shop_cost_amount
	shop_cost_type = item_data.shop_cost_type
	texture = item_data.ui_texture
	shop_manager = sm
	update_tooltip()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		shop_manager.try_to_buy_item(self)

func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip_instance = tooltip_scene.instantiate()
	var rich_label = tooltip_instance.get_node("Panel/RichTextLabel")
	rich_label.text = for_text
	return tooltip_instance

func _get_tooltip(_at_position: Vector2) -> String:
	return custom_tooltip_text

func update_tooltip():
	if item_data != null:
		if item_data is SeedsResource:
			#check documentation for string formatting and BBcode if confused
			custom_tooltip_text = "[b]{name}[/b]\n[i]{desc}[/i]".format({
				"name" = item_data.name,
				"desc" = item_data.description,
			})
