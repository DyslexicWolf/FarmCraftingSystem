extends PanelContainer
class_name ShopInventorySlot

var item_icon: TextureRect
var price_label: Label
var price_icon: TextureRect

func initialize(texture: Texture2D, price: int, currency_icon: Texture2D) -> void:
	item_icon = $ItemIcon
	price_label = $HBoxContainer/PriceLabel
	price_icon = $HBoxContainer/PriceIcon
	item_icon.texture = texture
	price_label.text = str(price)
	price_icon.texture = currency_icon
