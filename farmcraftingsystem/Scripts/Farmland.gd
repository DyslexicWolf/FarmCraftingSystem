extends TileMapLayer
class_name Farmland

func _ready() -> void:
	var hotbar = get_node("/root/Game/HUD/Hotbar")
	hotbar.planted_seeds.connect(_on_planted_seeds)

func _on_planted_seeds(cell_coords, item):
	print("in on planted seeds")
