extends Node

var crafting_options : Dictionary = {
	#temp use of a default icon until own made icons for crafting options
	reforge_harvest = {icon = load("res://Assets/Crops/Carrot_Crop.png"), text = "[b]Reforge[/b] an item with atleast 1 [b]harvest modifier[/b] into an item with the same amount but different harvest modifiers."},
	all_new_modifiers = {icon = load("res://Assets/Crops/Carrot_Crop.png"), text = "[b]Reforge[/b] a [color=white]normal[/color] item into an item with a random amount of modifiers."},
	add_one_modifier = {icon = load("res://Assets/Crops/Carrot_Crop.png"), text = "[b]Add[/b] a modifier to the item if possible."},
	remove_one_modifier = {icon = load("res://Assets/Crops/Carrot_Crop.png"), text = "[b]Remove[/b] a modifier from the item if possible."},
}
