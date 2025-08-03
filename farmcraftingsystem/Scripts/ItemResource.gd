extends Resource
class_name ItemResource

enum Rarity {normal, magic, rare, epic, legendary}

@export var name : String
@export var rarity : Rarity
@export var ui_texture : Texture2D
@export var yield_multiplier : int
@export var crit_harvest_chance : int
@export var grow_time : float
@export var seed_amount : int
@export_multiline var description : String
