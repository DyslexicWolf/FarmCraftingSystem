extends Node

var pickup_scenes : Dictionary = {
	Carrot = preload("res://Scenes/PickupScenes/CarrotPickup.tscn"),
	SweetBeets = preload("res://Scenes/PickupScenes/SweetBeetPickup.tscn"),
}

func get_pickup_scene(crop_name : String) -> Resource:
	print(pickup_scenes.get(crop_name))
	return pickup_scenes.get(crop_name)
