extends Node

var normal_modifiers : Dictionary = {
	yield_up_3 = {category = "yield", rank = 3, value = 3, weight = 10},
	yield_up_2 = {category = "yield", rank = 2, value = 7, weight = 5},
	yield_up_1 = {category = "yield", rank = 1, value = 11, weight = 2},

	seeds_up_3 = {category = "seeds", rank = 3, value = 2, weight = 12},
	seeds_up_2 = {category = "seeds", rank = 2, value = 4, weight = 6},
	seeds_up_1 = {category = "seeds", rank = 1, value = 7, weight = 3},

	crit_up_3 = {category = "crit_chance", rank = 3, value = 12, weight = 15},
	crit_up_2 = {category = "crit_chance", rank = 2, value = 24, weight = 10},
	crit_up_1 = {category = "crit_chance", rank = 1, value = 26, weight = 5},
	
	use_amount_3 = {category = "uses", rank = 3, value = 2, weight = 15},
	use_amount_2 = {category = "uses", rank = 2, value = 4, weight = 10},
	use_amount_1 = {category = "uses", rank = 1, value = 8, weight = 5},
}

func get_random_modifier(excluded_modifiers : Array[String]) -> String:
	var total_weight = 0
	for key in normal_modifiers.keys():
		if key in excluded_modifiers:
			continue
		total_weight += normal_modifiers[key]["weight"]
	
	print("Total weight of valid modifiers: ", total_weight)
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
