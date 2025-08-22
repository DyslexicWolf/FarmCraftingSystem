extends ItemResource
class_name SeedsResource

#modifier things
@export var yield_multiplier : float
@export var harvest_crit_chance : int
@export var base_harvest : int
@export var grow_time : float
@export var use_amount : int
var modifiers : Array[String] = []
var max_amount_modifiers : int = 6

#tile things
@export var planted_tile_id : int
@export var growing1_tile_id : int
@export var growing2_tile_id : int
@export var mature_tile_id : int

#shop things
@export var shop_cost_amount : int
@export var shop_cost_texture : Texture2D
var shop_cost_type = base_name
