extends Node

var normal_modifiers : Dictionary = {
	"yield_up_3": {"name": "yield_up", "rank": 3, "value": 3, "weight": 10},
	"yield_up_2": {"name": "yield_up", "rank": 2, "value": 7, "weight": 5},
	"yield_up_1": {"name": "yield_up", "rank": 1, "value": 11, "weight": 2},
	
	"seeds_up_3": {"name": "seeds_up", "rank": 3, "value": 2, "weight": 12},
	"seeds_up_2": {"name": "seeds_up", "rank": 2, "value": 4, "weight": 6},
	"seeds_up_1": {"name": "seeds_up", "rank": 1, "value": 7, "weight": 3},
	
	"crit_up_3": {"name": "crit_up", "rank": 3, "value": 12, "weight": 15},
	"crit_up_2": {"name": "crit_up", "rank": 2, "value": 24, "weight": 10},
	"crit_up_1": {"name": "crit_up", "rank": 1, "value": 26, "weight": 5},
}

func get_random_modifier(excluded_modifiers : Array) -> Dictionary:
	var total_weight = 0
	for key in normal_modifiers.keys():
		if key in excluded_modifiers:
			continue
		total_weight += normal_modifiers[key]["weight"]
	
	if total_weight == 0:
		return {} #no valid modifiers left
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_value = rng.randi_range(0, total_weight - 1)
	
	var cumulative = 0
	for key in normal_modifiers.keys():
		if key in excluded_modifiers:
			continue
		cumulative += normal_modifiers[key]["weight"]
		if random_value < cumulative:
			return normal_modifiers[key]
	
	return {} #should never happen, fallback
