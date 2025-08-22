extends Node

var normal_modifiers : Dictionary = {
	#ups the yield multiplier, this is used in the harvest calculation
	yield_up_3 = {category = "harvest_output", modifier_name = "yield_mult", rank = 3, value = 3, weight = 10},
	yield_up_2 = {category = "harvest_output", modifier_name = "yield_mult", rank = 2, value = 7, weight = 5},
	yield_up_1 = {category = "harvest_output", modifier_name = "yield_mult", rank = 1, value = 11, weight = 2},
	
	#ups the critchance for a harvest crit
	crit_up_3 = {category = "harvest_output", modifier_name = "crit_chance", rank = 3, value = 12, weight = 15},
	crit_up_2 = {category = "harvest_output", modifier_name = "crit_chance", rank = 2, value = 24, weight = 10},
	crit_up_1 = {category = "harvest_output", modifier_name = "crit_chance", rank = 1, value = 26, weight = 5},
	
	#ups the base harvest value, this is used in the harvest calculation
	base_harvest_up_3 = {category = "harvest_output", modifier_name = "base_harvest", rank = 3, value = 2, weight = 15},
	base_harvest_up_2 = {category = "harvest_output", modifier_name = "base_harvest", rank = 2, value = 4, weight = 10},
	base_harvest_up_1 = {category = "harvest_output", modifier_name = "base_harvest", rank = 1, value = 8, weight = 5},
	
	#ups how many times you can use the seeds for planting
	use_amount_3 = {category = "seed_efficiency", modifier_name = "uses", rank = 3, value = 2, weight = 15},
	use_amount_2 = {category = "seed_efficiency", modifier_name = "uses", rank = 2, value = 4, weight = 10},
	use_amount_1 = {category = "seed_efficiency", modifier_name = "uses", rank = 1, value = 8, weight = 5},
	
	#ups the growth speed of the planted seeds
	growth_speed_up_3 = {category = "seed_efficiency", modifier_name = "growth_speed_up", rank = 3, value = 2, weight = 15},
	growth_speed_up_2 = {category = "seed_efficiency", modifier_name = "growth_speed_up", rank = 2, value = 2, weight = 10},
	growth_speed_up_1 = {category = "seed_efficiency", modifier_name = "growth_speed_up", rank = 1, value = 2, weight = 5},
	
	##still needs to be implemented in farmland.gd and seedsresource.gd
	##implementation: add variables in seedsresource for multi_harvest, a bool, check if bool is true, if so, set the amount of multi harvest equal to the rank
	#bool to be able to harvest a farmland multiple times before having to replant
	multi_harvest_3 = {category = "special_harvest_effect", modifier_name = "multi_harvest", rank = 3, value = true, weight = 15},
	multi_harvest_2 = {category = "special_harvest_effect", modifier_name = "multi_harvest", rank = 2, value = true, weight = 10},
	multi_harvest_1 = {category = "special_harvest_effect", modifier_name = "multi_harvest", rank = 1, value = true, weight = 5},
	
	##still needs to be implement in farmland.gd and seedsresource.gd
	##implementation: add variables in seedsresource for mutatedharvest, a bool and a cropresource, check if bool is true, if so, add additional crops to spawn
	#bool to be able to have mutated harvest which makes a harvest spawn other crops than the planted ones
	mutated_harvest_3 = {category = "special_harvest_effect", modifier_name = "mutated_harvest", rank = 3, value = 5, weight = 15},
	mutated_harvest_2 = {category = "special_harvest_effect", modifier_name = "mutated_harvest", rank = 2, value = 8, weight = 10},
	mutated_harvest_1 = {category = "special_harvest_effect", modifier_name = "mutated_harvest", rank = 1, value = 12, weight = 5},
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

func get_random_modifier_by_category(excluded_modifiers : Array[String], category: String) -> String:
	var total_weight := 0
	var candidates: Array = []
	
	for key in normal_modifiers.keys():
		if key in excluded_modifiers:
			continue
		
		var mod: Dictionary = normal_modifiers[key]
		if mod.get("category", "") != category:
			continue
		
		candidates.append({ "key": key, "weight": mod["weight"] })
		total_weight += mod["weight"]
	
	if total_weight == 0:
		return ""
	
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var roll := rng.randi_range(0, total_weight - 1)
	
	var cumulative := 0
	for entry in candidates:
		cumulative += entry["weight"]
		if roll < cumulative:
			return entry["key"]
	
	return ""
