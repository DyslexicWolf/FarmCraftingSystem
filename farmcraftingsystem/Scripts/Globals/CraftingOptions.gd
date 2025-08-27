extends Node

const CRAFT_IDS := {
	REFORGE_HARVEST = "reforge_harvest",
	NEW_MODIFIERS = "new_modifiers",
	ADD_ONE_MODIFIER = "add_one_modifier",
	REMOVE_ONE_MODIFIER = "remove_one_modifier"
}

var crafting_options : Dictionary = {
	#temp use of a default icon until own made icons for crafting options
	reforge_harvest = {icon = load("res://Assets/Crops/Carrot_Crop.png"), text = "[b]Reforge[/b] an item with atleast 1 [b]harvest modifier[/b] into an item with the same amount but different harvest modifiers.", id_name = CRAFT_IDS.REFORGE_HARVEST},
	all_new_modifiers = {icon = load("res://Assets/Crops/Carrot_Crop.png"), text = "[b]Reforge[/b] a [color=yellow]normal[/color] item into an item with a random amount of modifiers.", id_name = CRAFT_IDS.NEW_MODIFIERS},
	add_one_modifier = {icon = load("res://Assets/Crops/Carrot_Crop.png"), text = "[b]Add[/b] a modifier to the item if possible.", id_name = CRAFT_IDS.ADD_ONE_MODIFIER},
	remove_one_modifier = {icon = load("res://Assets/Crops/Carrot_Crop.png"), text = "[b]Remove[/b] a modifier from the item if possible.", id_name = CRAFT_IDS.REMOVE_ONE_MODIFIER},
}
