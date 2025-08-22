extends Node

var normal_modifiers : Dictionary = {
	yield_up_3 = {category = "", modifier_name = "yield_mult", rank = 3, value = 3, weight = 10},
	yield_up_2 = {category = "", modifier_name = "yield_mult", rank = 2, value = 7, weight = 5},
	yield_up_1 = {category = "", modifier_name = "yield_mult", rank = 1, value = 11, weight = 2},
	
	crit_up_3 = {category = "", modifier_name = "crit_chance", rank = 3, value = 12, weight = 15},
	crit_up_2 = {category = "", modifier_name = "crit_chance", rank = 2, value = 24, weight = 10},
	crit_up_1 = {category = "", modifier_name = "crit_chance", rank = 1, value = 26, weight = 5},
	
	use_amount_3 = {category = "", modifier_name = "uses", rank = 3, value = 2, weight = 15},
	use_amount_2 = {category = "", modifier_name = "uses", rank = 2, value = 4, weight = 10},
	use_amount_1 = {category = "", modifier_name = "uses", rank = 1, value = 8, weight = 5},
	
	base_harvest_up_3 = {category = "", modifier_name = "base_harvest", rank = 3, value = 2, weight = 15},
	base_harvest_up_2 = {category = "", modifier_name = "base_harvest", rank = 2, value = 4, weight = 10},
	base_harvest_up_1 = {category = "", modifier_name = "base_harvest", rank = 1, value = 8, weight = 5},
	
	#still needs to be implemented in farmland.gd and seedsresource.gd
	multi_harvest_3 = {category = "special_harvest_effect", modifier_name = "multi_harvest", rank = 3, value = 50, weight = 15},
	multi_harvest_2 = {category = "special_harvest_effect", modifier_name = "multi_harvest", rank = 2, value = 65, weight = 10},
	multi_harvest_1 = {category = "special_harvest_effect", modifier_name = "multi_harvest", rank = 1, value = 85, weight = 5}
}

func get_random_modifier(excluded_modifiers : Array[String]) -> String:
	var total_weight = 0
	for key in normal_modifiers.keys():
		if key in excluded_modifiers:
			continue
		total_weight += normal_modifiers[key]["weight"]
	
	if total_weight == 0:
		return ""
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_value = rng.randi_range(0, total_weight - 1)
	
	var cumulative = 0
	for key in normal_modifiers.keys():
		if key in excluded_modifiers:
			continue
		cumulative += normal_modifiers[key]["weight"]
		if random_value < cumulative:
			return key
	
	return ""
