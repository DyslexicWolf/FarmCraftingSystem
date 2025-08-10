extends Resource
class_name ItemResource

enum Rarity {normal, magic, rare, epic, legendary}

@export var name : String
@export var base_name : String
@export var rarity : Rarity
@export var ui_texture : Texture2D
@export_multiline var description : String
